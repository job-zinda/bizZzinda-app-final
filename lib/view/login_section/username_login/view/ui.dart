import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PText_styles.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:provider/provider.dart';
import 'package:biz_zinda/view_model/username_login_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class UsernameLoginScreen extends StatefulWidget {
  const UsernameLoginScreen({super.key});

  @override
  State<UsernameLoginScreen> createState() => _UsernameLoginScreenState();
}

class _UsernameLoginScreenState extends State<UsernameLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _openWhatsApp() async {
    const phone = '+919847561998';
    final digits = phone.replaceAll('+', '');
    // Prefer universal link that works on iOS/Android if WhatsApp is installed (will open app); falls back to web
    final uri = Uri.parse('https://wa.me/$digits');
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        // Fallback to native scheme if needed
        final alt = Uri.parse('whatsapp://send?phone=$digits');
        await launchUrl(alt, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Silently ignore; optionally show a snackbar/toast if needed
    }
  }

  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username is required';
    final re = RegExp(r'^[A-Za-z0-9._-]{3,30}$');
    if (!re.hasMatch(v.trim())) {
      return '3–30 chars, letters/numbers/._-';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    final ok = v.length >= 8 && RegExp(r'[A-Z]').hasMatch(v) && RegExp(r'[0-9]').hasMatch(v);
    if (!ok) return 'Min 8, include uppercase and number';
    return null;
  }
  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<UsernameLoginViewModel>();
    EasyLoading.show(status: 'Signing in...');

    try {
      await vm.login(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;

      // Autofill update
      TextInput.finishAutofillContext(shouldSave: true);

      EasyLoading.dismiss();

      // Defer so the ViewModel's notifyListeners() rebuild flushes before the
      // Router navigates away — prevents _lifecycleState == inactive assertion.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.goNamed(PPages.loginSplashUi);
      });

    } catch (_) {
      EasyLoading.dismiss();

      // Show real backend error
      EasyLoading.showError(vm.error ?? 'Login failed');
    }
  }


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsernameLoginViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in',style: TextStyle(color:Colors.white,),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Welcome back', style: PTextStyles.titleLarge),
                const SizedBox(height: 24),
                CustomTextFeild(
                  controller: _usernameCtrl,
                  hintText: 'Username',
                  filColor: PColors.white,
                  borderRadius: 18,
                  borderColor: Color(0xFFFB8C00),
                  autofillHints: const [AutofillHints.username],
                  validation: _validateUsername,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                CustomTextFeild(
                  controller: _passwordCtrl,
                  hintText: 'Password',
                  filColor: PColors.white,
                  borderRadius: 18,
                  borderColor: Color(0xFFFB8C00),
                  obscureText: _obscure,
                  autofillHints: const [AutofillHints.password],
                  validation: _validatePassword,
                  suffixIcon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  sufixfn: () => setState(() => _obscure = !_obscure),
                ),
                const SizedBox(height: 24),
                CustomElavatedTextButton(
                  text: vm.loading ? 'Please wait...' : 'Sign in',
                  onPressed: vm.loading ? null : _onSubmit,
                  bgcolor: PColors.white,
                  textColor: Color(0xFFFB8C00),
                  borderRadius: 18,
                  borderColor: Color(0xFFFB8C00),
                  width: MediaQuery.sizeOf(context).width - 32,
                ),
                const SizedBox(height: 12),
                // CustomElavatedTextButton(
                //   text: 'New Account',
                //   onPressed: () {
                //     // Temporarily bypass OTP flow; keep for future reuse
                //     // context.pushNamed(PPages.phoneNumberUi);
                //     context.pushNamed(PPages.adduserpage);
                //   },
                //   bgcolor: Colors.purple.shade50,
                //   textColor: Color(0xFF8A4FFF),
                //   borderColor: Color(0xFF8A4FFF),
                //   borderRadius: 18,
                //   width: MediaQuery.sizeOf(context).width - 32,
                // ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // Temporarily disabled due to high OTP consumption; keep for future reuse
                      // context.pushNamed(PPages.changePasswordUi);
                      _openWhatsApp();
                    },
                    child: const Text('Forgot password?'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:go_router/go_router.dart';
// import 'package:jora_customer/Settings/until/PColors.dart';
// import 'package:jora_customer/Settings/widgets/custom_elevated_button.dart';
// import 'package:jora_customer/Settings/widgets/custom_text_feild.dart';
// import 'package:jora_customer/Settings/until/PPages.dart';
// import 'package:jora_customer/model/logged_in_user.dart';
// import 'package:jora_customer/view_model/username_login_view_model.dart';
// import 'package:provider/provider.dart';
//
// class UsernameLoginScreen extends StatefulWidget {
// const UsernameLoginScreen({super.key});
//
// @override
// State<UsernameLoginScreen> createState() => _UsernameLoginScreenState();
// }
//
// class _UsernameLoginScreenState extends State<UsernameLoginScreen> {
//
// final _formKey = GlobalKey<FormState>();
//
// final _usernameCtrl = TextEditingController();
// final _passwordCtrl = TextEditingController();
// final _emailCtrl = TextEditingController();
// final _otpCtrl = TextEditingController();
//
// bool _obscure = true;
// bool _otpSent = false;
// bool _emailVerified = false;
//
// final Dio _dio = Dio(
// BaseOptions(
// baseUrl: 'https://server2.jobzinda.com',
// connectTimeout: const Duration(seconds: 15),
// receiveTimeout: const Duration(seconds: 15),
// ),
// );
//
// // ================= VALIDATIONS =================
//
// String? _validateUsername(String? v) {
// if (v == null || v.trim().isEmpty) {
// return "Username is required";
// }
// if (v.length < 3) {
// return "Minimum 3 characters required";
// }
// return null;
// }
//
// String? _validatePassword(String? v) {
// if (v == null || v.isEmpty) {
// return "Password required";
// }
// if (v.length < 8) {
// return "Password must be at least 8 characters";
// }
// return null;
// }
//
// String? _validateEmail(String? v) {
// if (v == null || v.trim().isEmpty) {
// return "Email required";
// }
// if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
// return "Enter valid email";
// }
// return null;
// }
//
// String? _validateOtp(String? v) {
// if (!_otpSent) return null;
//
// if (v == null || v.isEmpty) {
// return "Enter OTP";
// }
//
// if (v.length != 6) {
// return "OTP must be 6 digits";
// }
//
// return null;
// }
//
// // ================= SEND OTP =================
//
// Future<void> _sendOtp() async {
//
// if (_validateEmail(_emailCtrl.text) != null) {
// EasyLoading.showError("Enter valid email");
// return;
// }
//
// final email = _emailCtrl.text.trim().toLowerCase();
//
// EasyLoading.show(status: "Sending OTP...");
//
// try {
//
// final resp = await _dio.post(
// '/api/v1/auth/send-email-otp',
// data: {
// "email": email,
// "updateEmail": true
// },
// );
//
// print("SEND OTP RESPONSE: ${resp.data}");
//
// EasyLoading.dismiss();
//
// if (resp.data['status'] == true) {
//
// setState(() {
// _otpSent = true;
// });
//
// EasyLoading.showSuccess("OTP sent to email");
//
// } else {
//
// EasyLoading.showError(resp.data['message'] ?? "Failed");
//
// }
//
// } catch (e) {
//
// EasyLoading.dismiss();
// print(e);
// EasyLoading.showError("Error sending OTP");
//
// }
//
// }
//
// // ================= VERIFY OTP =================
//
// Future<void> _verifyOtp() async {
//
// if (_validateOtp(_otpCtrl.text) != null) {
// EasyLoading.showError("Enter valid OTP");
// return;
// }
//
// final email = _emailCtrl.text.trim().toLowerCase();
// final otp = _otpCtrl.text.trim();
//
// print("EMAIL: $email");
// print("OTP: $otp");
//
// EasyLoading.show(status: "Verifying OTP...");
//
// try {
//
// final resp = await _dio.post(
// '/api/v1/auth/verify-email-otp',
// data: {
// "email": email,
// "otp": otp,
// "updateEmail": true
// },
// );
//
// print("VERIFY RESPONSE: ${resp.data}");
//
// EasyLoading.dismiss();
//
// if (resp.data['status'] == true) {
//
// setState(() {
// _emailVerified = true;
// });
//
// EasyLoading.showSuccess("Email verified");
//
// } else {
//
// EasyLoading.showError(resp.data['message'] ?? "Verification failed");
//
// }
//
// } catch (e) {
//
// EasyLoading.dismiss();
// print(e);
//
// EasyLoading.showError("OTP verification failed");
//
// }
//
// }
//
// // ================= LOGIN =================
//
// Future<void> _login() async {
//
// if (!_formKey.currentState!.validate()) return;
//
// if (!_emailVerified) {
// EasyLoading.showError("Verify email first");
// return;
// }
//
// final vm = context.read<UsernameLoginViewModel>();
//
// EasyLoading.show(status: "Signing in...");
//
// try {
//
// await vm.login(
// username: _usernameCtrl.text.trim(),
// password: _passwordCtrl.text,
// );
//
// EasyLoading.dismiss();
//
// LoggedInUser.lastLoginWasEmailOtp = false;
//
// if (!mounted) return;
//
// context.goNamed(PPages.loginSplashUi);
//
// } catch (_) {
//
// EasyLoading.dismiss();
// EasyLoading.showError(vm.error ?? "Login failed");
//
// }
//
// }
//
// // ================= UI =================
//
// @override
// Widget build(BuildContext context) {
//
// final vm = context.watch<UsernameLoginViewModel>();
//
// return Scaffold(
//
// appBar: AppBar(
// title: const Text(
// "Sign in",
// style: TextStyle(color: Colors.white),
// ),
// ),
//
// body: Padding(
//
// padding: const EdgeInsets.all(16),
//
// child: Form(
//
// key: _formKey,
//
// child: SingleChildScrollView(
//
// child: Column(
//
// children: [
//
// const SizedBox(height: 20),
//
// CustomTextFeild(
// controller: _usernameCtrl,
// hintText: "Username",
// filColor: PColors.white,
// borderRadius: 18,
// borderColor: const Color(0xFF8A4FFF),
// validation: _validateUsername,
// ),
//
// const SizedBox(height: 16),
//
// CustomTextFeild(
// controller: _passwordCtrl,
// hintText: "Password",
// filColor: PColors.white,
// borderRadius: 18,
// borderColor: const Color(0xFF8A4FFF),
// obscureText: _obscure,
// validation: _validatePassword,
// suffixIcon: Icon(
// _obscure ? Icons.visibility : Icons.visibility_off,
// ),
// sufixfn: () {
// setState(() {
// _obscure = !_obscure;
// });
// },
// ),
//
// const SizedBox(height: 16),
//
// CustomTextFeild(
// controller: _emailCtrl,
// hintText: "Email",
// filColor: PColors.white,
// borderRadius: 18,
// borderColor: const Color(0xFF8A4FFF),
// keyboardType: TextInputType.emailAddress,
// validation: _validateEmail,
// ),
//
// const SizedBox(height: 12),
//
// CustomElavatedTextButton(
// text: "Send OTP",
// onPressed: _sendOtp,
// bgcolor: PColors.white,
// textColor: const Color(0xFF8A4FFF),
// borderRadius: 18,
// borderColor: const Color(0xFF8A4FFF),
// ),
//
// const SizedBox(height: 12),
//
// if (_otpSent) ...[
//
// CustomTextFeild(
// controller: _otpCtrl,
// hintText: "Enter OTP",
// filColor: PColors.white,
// borderRadius: 18,
// borderColor: const Color(0xFF8A4FFF),
// keyboardType: TextInputType.number,
// maxLength: 6,
// validation: _validateOtp,
// inputFormatters: [
// FilteringTextInputFormatter.digitsOnly
// ],
// ),
//
// const SizedBox(height: 12),
//
// CustomElavatedTextButton(
// text: "Verify OTP",
// onPressed: _verifyOtp,
// bgcolor: PColors.white,
// textColor: const Color(0xFF8A4FFF),
// borderRadius: 18,
// borderColor: const Color(0xFF8A4FFF),
// ),
//
// ],
//
// const SizedBox(height: 20),
//
// CustomElavatedTextButton(
// text: vm.loading ? "Please wait..." : "Sign in",
// onPressed: (!_emailVerified || vm.loading)
// ? null
//     : _login,
// bgcolor: PColors.white,
// textColor: const Color(0xFF8A4FFF),
// borderRadius: 18,
// borderColor: const Color(0xFF8A4FFF),
// ),
//
// ],
//
// ),
//
// ),
//
// ),
//
// ),
//
// );
//
// }
//
// }
//
//
//
//
//
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:jora_customer/Settings/until/PColors.dart';
// import 'package:jora_customer/Settings/widgets/custom_elevated_button.dart';
// import 'package:jora_customer/Settings/widgets/custom_text_feild.dart';
// import 'package:jora_customer/model/logged_in_user.dart';
// import '../../../home_section/home_pages/view/home_screen.dart';
//
// class UsernameLoginScreen extends StatefulWidget {
//   const UsernameLoginScreen({super.key});
//
//   @override
//   State<UsernameLoginScreen> createState() => _UsernameLoginScreenState();
// }
//
// class _UsernameLoginScreenState extends State<UsernameLoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameCtrl = TextEditingController();
//   final _passwordCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _otpCtrl = TextEditingController();
//
//   bool _obscure = true;
//   bool _isLoggedIn = false;
//   bool _otpSent = false;
//
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'http://10.0.2.2:4001', // local backend
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//     ),
//   );
//
//   // ================= LOGIN =================
//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     // Simulate login (replace with your UsernameLoginViewModel)
//     EasyLoading.show(status: "Signing in...");
//     await Future.delayed(const Duration(seconds: 1));
//     EasyLoading.dismiss();
//     setState(() {
//       _isLoggedIn = true;
//     });
//     EasyLoading.showSuccess("Login success");
//   }
//
//   // ================= SEND EMAIL OTP =================
//   Future<void> _sendOtp() async {
//     final email = _emailCtrl.text.trim();
//     if (email.isEmpty) {
//       EasyLoading.showError("Enter email");
//       return;
//     }
//
//     EasyLoading.show(status: "Sending OTP...");
//     try {
//       final resp = await _dio.post(
//         '/api/v1/auth/send-email-otp',
//         data: {"email": email},
//       );
//
//       EasyLoading.dismiss();
//
//       if (resp.data['status'] == true) {
//         setState(() {
//           _otpSent = true;
//         });
//         EasyLoading.showSuccess("OTP sent to email");
//       } else {
//         EasyLoading.showError(resp.data['message'] ?? "Failed to send OTP");
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       print(e);
//       EasyLoading.showError("Error sending OTP");
//     }
//   }
//
//   // ================= VERIFY EMAIL OTP =================
//   Future<void> _verifyOtp() async {
//     final otp = _otpCtrl.text.trim();
//     final email = _emailCtrl.text.trim();
//
//     if (otp.length != 6) {
//       EasyLoading.showError("Enter valid 6-digit OTP");
//       return;
//     }
//
//     EasyLoading.show(status: "Verifying OTP...");
//     try {
//       final resp = await _dio.post('/api/v1/auth/verify-email-otp', data: {
//         "email": email,
//         "otp": otp,
//         "countryCode": LoggedInUser.countryCode ?? "+91",
//         "mobileNumber": LoggedInUser.phoneNumber ?? ""
//       });
//
//       EasyLoading.dismiss();
//
//       if (resp.data['status'] == true) {
//         // Update user data and tokens
//         LoggedInUser.login(resp.data['data']);
//
//         EasyLoading.showSuccess("Email verified successfully");
//
//         // Navigate to Home
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//               (route) => false,
//         );
//       } else {
//         EasyLoading.showError(resp.data['message'] ?? "OTP verification failed");
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       print(e);
//       EasyLoading.showError("Error verifying OTP");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign in")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 CustomTextFeild(
//                   controller: _usernameCtrl,
//                   hintText: "Username",
//                   filColor: PColors.white,
//                   borderRadius: 18,
//                   borderColor: const Color(0xFF8A4FFF),
//                   validation: (v) =>
//                   v == null || v.isEmpty ? "Enter username" : null,
//                 ),
//                 const SizedBox(height: 16),
//                 CustomTextFeild(
//                   controller: _passwordCtrl,
//                   hintText: "Password",
//                   filColor: PColors.white,
//                   borderRadius: 18,
//                   borderColor: const Color(0xFF8A4FFF),
//                   obscureText: _obscure,
//                   validation: (v) =>
//                   v == null || v.length < 6 ? "Enter valid password" : null,
//                   suffixIcon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
//                   sufixfn: () => setState(() => _obscure = !_obscure),
//                 ),
//                 const SizedBox(height: 20),
//                 CustomElavatedTextButton(
//                   text: "Login",
//                   onPressed: _login,
//                   bgcolor: PColors.white,
//                   textColor: const Color(0xFF8A4FFF),
//                   borderRadius: 18,
//                   borderColor: const Color(0xFF8A4FFF),
//                 ),
//                 const SizedBox(height: 30),
//
//                 // Email & OTP Section
//                 if (_isLoggedIn) ...[
//                   CustomTextFeild(
//                     controller: _emailCtrl,
//                     hintText: "Enter Email",
//                     filColor: PColors.white,
//                     borderRadius: 18,
//                     borderColor: const Color(0xFF8A4FFF),
//                   ),
//                   const SizedBox(height: 12),
//                   CustomElavatedTextButton(
//                     text: "Send OTP",
//                     onPressed: _sendOtp,
//                     bgcolor: PColors.white,
//                     textColor: const Color(0xFF8A4FFF),
//                     borderRadius: 18,
//                     borderColor: const Color(0xFF8A4FFF),
//                   ),
//                   if (_otpSent) ...[
//                     const SizedBox(height: 12),
//                     CustomTextFeild(
//                       controller: _otpCtrl,
//                       hintText: "Enter OTP",
//                       filColor: PColors.white,
//                       borderRadius: 18,
//                       borderColor: const Color(0xFF8A4FFF),
//                       keyboardType: TextInputType.number,
//                       maxLength: 6,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
//                     const SizedBox(height: 12),
//                     CustomElavatedTextButton(
//                       text: "Verify OTP & Save",
//                       onPressed: _verifyOtp,
//                       bgcolor: PColors.white,
//                       textColor: const Color(0xFF8A4FFF),
//                       borderRadius: 18,
//                       borderColor: const Color(0xFF8A4FFF),
//                     ),
//                   ],
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

