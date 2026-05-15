import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';
import '../main.dart';


class AppLinkService {
  // Singleton setup
  static final AppLinkService _instance = AppLinkService._internal();
  factory AppLinkService() => _instance;
  AppLinkService._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  Uri? _initialUri;

  // State
  bool _isInitializationComplete = false;

  /// Returns true if the app has finished its initial loading sequence.
  bool get isInitializationComplete => _isInitializationComplete;

  Uri? _pendingLink;
  String? _lastProcessedPath;
  DateTime? _lastProcessedTime;

  Future<void> init() async {
    debugPrint("APP LINKS: Initializing AppLinkService...");
    try {
      _initialUri = await _appLinks.getInitialLink()
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
      if (_initialUri != null) {
        debugPrint("APP LINKS: Initial URI found: $_initialUri");
      }
    } on PlatformException {
      debugPrint("APP LINKS: Failed to get initial link.");
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleStreamLink,
      onError: (Object error) => debugPrint("APP LINKS: Stream error: $error"),
    );
  }

  void _handleStreamLink(Uri uri) {
    debugPrint("APP LINKS: Stream link received: $uri");
    if (!_isInitializationComplete) {
      debugPrint("APP LINKS: App not ready, storing as pending link.");
      _pendingLink = uri;
    } else {
      _processLinkAndNavigate(uri);
    }
  }

  /// To be called from SplashScreen to get the initial link path without navigating.
  Future<String?> completeInitializationAndGetPath() async {
    debugPrint("APP LINKS: Completing initialization and checking for pending link path.");
    _isInitializationComplete = true;

    final linkToProcess = _pendingLink ?? _initialUri;
    _pendingLink = null;
    _initialUri = null;

    if (linkToProcess != null) {
      debugPrint("APP LINKS: Found startup link: $linkToProcess");
      return _getPathFromUri(linkToProcess);
    } else {
      debugPrint('APP LINKS: No startup link to process.');
      return null;
    }
  }

  /// Processes a link and navigates. Used for links that arrive when the app is running.
  void _processLinkAndNavigate(Uri uri) {
    final path = _getPathFromUri(uri);
    if (path == null) {
      debugPrint("APP LINKS: Could not extract a valid path from URI: $uri");
      return;
    }

    final now = DateTime.now();
    if (_lastProcessedPath == path &&
        _lastProcessedTime != null &&
        now.difference(_lastProcessedTime!).inSeconds < 3) {
      debugPrint("APP LINKS: Debouncing duplicate link path: $path");
      return;
    }



    // Prepend '/' to make it an absolute path for a clean navigation stack.
    final absolutePath = '/$path';
    debugPrint("APP LINKS: Navigating to path '$absolutePath'");
    _lastProcessedPath = path;
    _lastProcessedTime = now;
    // mainAppRouter.push(absolutePath);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainAppRouter.go(absolutePath);
    });
  }
  // shabna
  String? _getPathFromUri(Uri uri) {
    debugPrint("APP LINKS: incoming uri => $uri");

    /// 🌐 WEB LINKS
    if ((uri.scheme == 'http' || uri.scheme == 'https') &&
        (uri.host == 'bizzinda.com' ||
            uri.host == 'www.bizzinda.com' ||
            uri.host == 'server2.jobzinda.com')) {

      if (uri.pathSegments.isNotEmpty) {
        final first = uri.pathSegments.first;

        /// PROFILE
        if (first == 'profile') {
          return uri.pathSegments.join('/');
        }

        /// OFFERING
        if (first == 'offering') {
          return uri.pathSegments.join('/');
        }
      }
    }

    /// 📱 CUSTOM SCHEME
    else if (uri.scheme == 'bizzinda') {

      if (uri.host == 'offering' &&
          uri.pathSegments.isNotEmpty) {
        return 'offering/${uri.pathSegments.first}';
      }

      if (uri.host == 'profile' &&
          uri.pathSegments.isNotEmpty) {
        return 'profile/${uri.pathSegments.first}';
      }
    }

    debugPrint(
      "APP LINKS: No match. scheme=${uri.scheme}, host=${uri.host}, path=${uri.path}",
    );

    return null;
  }
  // String? _getPathFromUri(Uri uri) {
  //   // Handle http/https links like https://jobzinda.com/profile/123
  //   if ((uri.scheme == 'http' || uri.scheme == 'https') && uri.host == 'jobzinda.com') {
  //     // Using pathSegments for robust parsing, e.g., ['profile', 'userId']
  //     if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'profile') {
  //       return uri.pathSegments.join('/'); // "profile/userId"
  //     }
  //   }
  //   // Handle custom scheme links like com.jobzinda.customers://profile/123
  //   else if (uri.scheme == 'com.jobzinda.customers' && uri.host == 'profile' && uri.pathSegments.isNotEmpty) {
  //     // Construct the relative path for the nested route
  //     return 'profile/${uri.pathSegments.join('/')}'; // "profile/userId"
  //   }
  //   debugPrint("APP LINKS: URI scheme '${uri.scheme}' or host '${uri.host}' did not match expected format.");
  //   return null;
  // }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
