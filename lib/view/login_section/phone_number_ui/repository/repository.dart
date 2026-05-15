import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:biz_zinda/main.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
import 'package:provider/provider.dart';

class FirebaseAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signinWithPhone(
    String phoneNumber, {
    required Function(FirebaseAuthException val) verificationFailed,
    required Function(String verificationId, int? forceResendingToken) codeSent,
    required Function(User? user) onAutoVerify,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          var cred =
              await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          onAutoVerify(cred.user);
        },
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> verifyOtp(String userOtp, String verficationId) async {
    User? user;
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verficationId, smsCode: userOtp);
      await _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((value) {
        user = value.user;
      });
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> loginwithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleuse = await GoogleSignIn().signIn();
      final googleAuth = await googleuse?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      UserCredential? crede = await _firebaseAuth.signInWithCredential(cred);
      String email = crede.user!.email!;
      navigatorKey.currentContext!
          .read<LoginPhoneNumberViewModel>()
          .checkUserExstsEmail(navigatorKey.currentContext!, email);
      return crede;
    } catch (e) {}
    return null;
  }

  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      print("User signed out successfully.");
      return;
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }
}
