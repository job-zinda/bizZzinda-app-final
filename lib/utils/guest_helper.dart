import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/main.dart' show navigatorKey;

/// Returns true (and shows the login-required sheet) if the current
/// session is a guest session. Use as a guard at the top of any action
/// that requires an authenticated user:
///   if (isGuestUser(context)) return;
bool isGuestUser(BuildContext context) {
  if (LoggedInUser.isGuest) {
    showLoginRequiredDialog(context);
    return true;
  }
  return false;
}

void showLoginRequiredDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: Color(0xFFFB8C00)),
            const SizedBox(height: 16),
            const Text(
              'Login Required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please login or create an account to use this feature.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB8C00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await LoggedInUser.clearUserData();
                  if (!context.mounted) return;
                  final outerContext = navigatorKey.currentContext;
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (outerContext != null && outerContext.mounted) {
                      outerContext.go(PPages.loginWelcomeScreenUi);
                    }
                  });
                },
                child: const Text(
                  'Login / Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Continue as Guest',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    },
  );
}
