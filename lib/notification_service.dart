// fcm_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:biz_zinda/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/model/conversation_model.dart';
import 'package:biz_zinda/model/post_model.dart';
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
import 'package:biz_zinda/view_model/chat_badge_viewmodel.dart';
import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
// import 'package:jora_customer/view_model/user_view_model.dart'; // For current user ID - FILE NOT FOUND

import 'package:biz_zinda/main.dart' as main_app; // Make sure this imports your navigatorKey

class FCMService {
  static final FCMService _instance = FCMService._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken;
  bool _isRequestingPermission = false;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  factory FCMService() {
    return _instance;
  }

  FCMService._internal();

  Future<void> initialize() async {
    // Local notifications channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _requestPermissions();

    fcmToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fcmToken");

    // Show foreground notification only; don't navigate or call APIs here
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;
      final type = data['type'];
      final actionId = data['actionId'];

      final context = main_app.navigatorKey.currentContext!;
      final postViewModel = context.read<PostViewModel>();

      switch (type) {
        case 'comment':
        case 'like':
        case 'profileView':
        case 'follow':
          context.read<BadgeViewModel>().fetchNotificationCount();
          if (actionId != null) {
            postViewModel.postDetails = PostModel(sId: actionId);
            await postViewModel.fetchPostDetails(); // ✅ Call API in foreground
          }
          break;

        case 'message':
          context.read<BadgeViewModel>().fetchUserMessageMessageCount();
          if (actionId != null) {
            await context
                .read<ChatDetailsViewModel>()
                .fetchAllMessageProfile(actionId); // ✅
          }
          break;

        case 'adminMessage':
          context.read<BadgeViewModel>().fetchAdminMessageCount();
          await context
              .read<ChatDetailsViewModel>()
              .fetchAllQueryMessages(); // ✅
          break;
      }

      _showNotification(message); // Still show local notification
    });

    // Navigate only when user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Opened app from notification: ${message.notification?.title}");
      _handleNavigation(message.data);
    });

    // Handle notification that launched the app (from terminated)
    RemoteMessage? initialMessage =
    await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _requestPermissions() async {
    if (_isRequestingPermission) return;

    try {
      _isRequestingPermission = true;

      NotificationSettings settings =
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else {
        print('User declined or has not accepted permission');
      }
    } finally {
      _isRequestingPermission = false;
    }
  }

  void _showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/launcher_icon',
          ),
        ),
      );
    }
  }

  void _handleNavigation(Map<String, dynamic> data) async {
    final String? type = data['type'];
    final String? actionId = data['actionId'];

    if (type == 'subscription') {
      print("Subscription notification received.");
      return;
    }

    if (type == null || actionId == null) return;

    final context = main_app.navigatorKey.currentContext!;
    final postViewModel = context.read<PostViewModel>();

    switch (type) {
      case 'comment':
      case 'like':
        EasyLoading.show(status: "Loading post...");
        try {
          postViewModel.postDetails = PostModel(sId: actionId);
          await postViewModel.fetchPostDetails();
          context.read<BadgeViewModel>().notificationRead();

          if (context.mounted) {
            if (postViewModel.postDetails != null) {
              context.pushNamed(PPages.profilePostDetailsUi);
            } else {
              print("Error: postDetails is null, cannot navigate to ProfilePostDetailsUi");
              EasyLoading.showError("Failed to load post details.");
            }
          }
        } catch (e) {
          print('Error handling notification navigation for post: $e');
          EasyLoading.showError("Failed to load post details.");
        } finally {
          EasyLoading.dismiss();
        }
        break;

      case 'profileView':
      case 'follow':
        EasyLoading.show(status: "Loading profile...");
        try {
          bool? status =
          await postViewModel.fetchOtherUserProfileDetails(userID: actionId);
          context.read<BadgeViewModel>().notificationRead();
          if (status == true && context.mounted) {
            context.pushNamed(PPages.profileView, pathParameters: {'userId': actionId});
          } else {
            EasyLoading.showError("Failed to load profile.");
          }
        } catch (e) {
          print('Error handling notification navigation for profile: $e');
          EasyLoading.showError("Failed to load profile.");
        } finally {
          EasyLoading.dismiss();
        }
        break;

      case 'message':
        context
            .read<PostViewModel>()
            .fetchOtherUserProfileDetails(userID: actionId);
        context.read<ChatDetailsViewModel>().pageType = "from profile";
        context.read<ChatDetailsViewModel>().fetchAllMessageProfile(actionId);

        final otherUserName = postViewModel.otherUser?.name ?? data['sender_name'] as String? ?? 'User';
        final otherUserImage = postViewModel.otherUser?.profileImageUrl ?? data['sender_image'] as String? ?? '';
        final chatIdFromNotification = data['chat_id'] as String?;

        if (chatIdFromNotification == null) {
          print("Error: chat_id not found in notification payload for message type.");
          EasyLoading.showError("Failed to open chat. Missing chat ID.");
          return;
        }

        context.pushNamed(PPages.chatDetailsPageui);
        break;

      case 'adminMessage':
        context.read<ChatDetailsViewModel>().pageType = "lets plan";
        context.read<ChatDetailsViewModel>().fetchAllQueryMessages();

        final adminName = data['admin_name'] as String? ?? 'Support';
        final adminImage = data['admin_image'] as String? ?? ''; // Default admin avatar if not in payload
        final chatIdForAdmin = actionId;
        final adminUserId = data['admin_user_id'] as String? ?? 'admin_support_user';

        context.pushNamed(PPages.chatDetailsPageui);
        break;

      default:
        print("Unhandled notification type: $type");
    }
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized.
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  // Since this is a background isolate, we need to setup notifications separately.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  // And show the notification.
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/launcher_icon',
        ),
      ),
    );
  }

  print('Handling a background message: ${message.messageId}');
}