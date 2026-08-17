import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:biz_zinda/utils/api_url.dart';

/// Shares a user's profile via the OS share sheet as a deep link.
///
/// Mirrors the offer-share flow in [OfferSection]: it shares the profile
/// picture as an attachment (downloaded to a temp file) together with a
/// deep-link URL, and falls back to text-only sharing on any error.
///
/// The shared URL (`https://server2.jobzinda.com/profile/<userId>`) is an
/// Android App Link, so tapping it opens the app on the profile screen.
Future<void> shareProfile({
  required String userId,
  String? userName,
  String? profileImageUrl,
}) async {
  final String id = userId.trim();

  if (id.isEmpty) {
    debugPrint("PROFILE SHARE => invalid/empty userId");
    return;
  }

  final String shareUrl = "https://server2.jobzinda.com/profile/$id";

  final String displayName =
      (userName != null && userName.trim().isNotEmpty) ? userName.trim() : "this profile";

  final String text = """
🔥 Check out $displayName on Bizzinda!

👉 Open Profile:
$shareUrl
""";

  try {
    String imageUrl = (profileImageUrl ?? "").trim();

    if (imageUrl.isNotEmpty && !imageUrl.startsWith("http")) {
      imageUrl = "${AppUrl.baseurl}/$imageUrl";
    }

    if (imageUrl.isNotEmpty) {
      final response = await http.get(Uri.parse(imageUrl));

      final tempDir = await getTemporaryDirectory();

      final file = File('${tempDir.path}/profile.jpg');

      await file.writeAsBytes(response.bodyBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );
    } else {
      await Share.share(text);
    }
  } catch (e) {
    debugPrint("PROFILE SHARE ERROR => $e");
    await Share.share(text);
  }
}
