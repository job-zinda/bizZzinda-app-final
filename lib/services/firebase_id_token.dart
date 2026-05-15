import 'package:firebase_auth/firebase_auth.dart';

class FirebaseIdTokenProvider {
  static Future<String> getIdTokenOrThrow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No Firebase user. Please complete OTP verification first.');
    }
    // Try a force refresh to avoid expired/absent tokens
    await user.reload();
    final token = await user.getIdToken(true);
    if (token == null) {
      throw Exception('Failed to fetch Firebase ID token');
    }
    return token;
  }
}
