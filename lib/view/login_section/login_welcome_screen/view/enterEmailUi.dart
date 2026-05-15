// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:dio/dio.dart';
// import 'package:jora_customer/Settings/widgets/custom_elevated_button.dart';
// import '../../../../utils/api_url.dart';
//
// class EnterEmailScreen extends StatefulWidget {
//   final Map data;
//   const EnterEmailScreen({super.key, required this.data});
//
//   @override
//   State<EnterEmailScreen> createState() => _EnterEmailScreenState();
// }
//
// class _EnterEmailScreenState extends State<EnterEmailScreen> {
//   final TextEditingController otpController = TextEditingController();
//   final Dio dio = Dio();
//
//   @override
//   Widget build(BuildContext context) {
//     final email = widget.data["email"] ?? "your email";
//
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 22),
//           child: Container(
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 15, offset: const Offset(0, 6))],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.mark_email_read, size: 80, color: Color(0xFF8A4FFF)),
//                 const SizedBox(height: 15),
//                 const Text("Verify your email", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 Text("OTP sent to\n$email", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
//                 const SizedBox(height: 25),
//                 TextField(
//                   controller: otpController,
//                   keyboardType: TextInputType.number,
//                   maxLength: 6,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(letterSpacing: 10, fontSize: 20, fontWeight: FontWeight.bold),
//                   decoration: InputDecoration(
//                     hintText: "------",
//                     counterText: "",
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(14),
//                       borderSide: const BorderSide(color: Color(0xFF8A4FFF), width: 2),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 CustomElavatedTextButton(
//                   width: double.infinity,
//                   text: "Verify OTP",
//                   bgcolor: const Color(0xFF8A4FFF),
//                   textColor: Color(0xFF8A4FFF),
//                   onPressed: verifyOtp,
//                 ),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   onPressed: resendOtp,
//                   child: const Text("Resend OTP", style: TextStyle(color: Color(0xFF8A4FFF), fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> verifyOtp() async {
//     final otp = otpController.text.trim();
//     if (otp.length != 6) {
//       EasyLoading.showError("Enter valid OTP");
//       return;
//     }
//
//     EasyLoading.show(status: "Verifying...");
//     try {
//       final res = await dio.post(
//         "${AppUrl.baseurl}/api/v1/auth/verify-email-otp",
//         data: {
//           "email": widget.data["email"],
//           "otp": otp,
//         },
//       );
//       print(res.data);
//       EasyLoading.dismiss();
//
//       print("VERIFY OTP RESPONSE: ${res.data}");
//
//       if (res.data["status"] == true) {
//
//         EasyLoading.showSuccess("Email verified");
//
//         Navigator.pop(context, true); // ✅ Return success
//
//       } else {
//
//         EasyLoading.showError(res.data["message"] ?? "Invalid OTP");
//
//       }
//
//     } on DioException catch (e) {
//
//       EasyLoading.dismiss();
//
//       if (e.response != null) {
//         EasyLoading.showError(e.response?.data["message"] ?? "OTP verification failed");
//       } else {
//         EasyLoading.showError("Network error");
//       }
//
//     } catch (e) {
//
//       EasyLoading.dismiss();
//       EasyLoading.showError("Something went wrong");
//
//     } catch (e) {
//       EasyLoading.dismiss();
//       EasyLoading.showError("Verification failed");
//     }
//   }
//
//   Future<void> resendOtp() async {
//     EasyLoading.show(status: "Sending OTP...");
//     try {
//       final res = await dio.post("${AppUrl.baseurl}/api/v1/auth/send-email-otp", data: {"email": widget.data["email"]});
//       EasyLoading.dismiss();
//       if (res.data["status"] == true) {
//         EasyLoading.showSuccess("OTP sent again");
//       } else {
//         EasyLoading.showError("Failed to resend OTP");
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       EasyLoading.showError("Failed to resend OTP");
//     }
//   }
// }