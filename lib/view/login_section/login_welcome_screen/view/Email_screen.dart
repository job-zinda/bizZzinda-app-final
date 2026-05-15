import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/api_url.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final Dio dio = Dio();

  bool otpSent = false;

  Widget purpleButton(String text, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFBFA2FF),
            Color(0xFF8A4FFF),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// SEND OTP
  Future<void> sendOtp() async {

    final email = emailController.text.trim();

    if (email.isEmpty) {
      EasyLoading.showError("Enter email");
      return;
    }

    try {

      EasyLoading.show(status: "Checking email...");

      final response = await dio.post(
        Api.sentOtp,
        data: {"email": email},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      EasyLoading.dismiss();

      print(response.data);

      /// EMAIL EXISTS
      if (response.data['status'] == true) {

        setState(() {
          otpSent = true;
        });

        EasyLoading.showSuccess("OTP sent");

      }

      /// EMAIL NOT REGISTERED
      else {

        EasyLoading.showInfo("Email not registered");

        if (context.mounted) {
          GoRouter.of(context).go(
            '/add-user',
            extra: email,
          );
        }

      }

    } catch (e) {

      EasyLoading.dismiss();
      EasyLoading.showError("Something went wrong");

    }

  }



  Future<void> verifyOtp(String otp) async {

    final email = emailController.text.trim();

    if (otp.length != 6) {
      EasyLoading.showError("Enter valid OTP");
      return;
    }

    try {

      EasyLoading.show(status: "Verifying...");

      final response = await dio.post(
        Api.verifyOtp,
        data: {
          "email": email,
          "otp": otp,
        },
      );

      EasyLoading.dismiss();

      if (response.data['status'] == true) {

        EasyLoading.showSuccess("Login Success");

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("user_id", response.data['user']['id'].toString());
        await prefs.setString("user_email", email);

        if (context.mounted) {
          GoRouter.of(context).go('/home');
        }

      } else {

        EasyLoading.showError("Invalid OTP");

      }

    } catch (e) {

      EasyLoading.dismiss();
      EasyLoading.showError("Verification failed");

    }

  }



  Widget otpBox() {

    return Pinput(
      length: 6,
      controller: otpController,

      onCompleted: (pin) {
        verifyOtp(pin);
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Email Verification"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Enter Email",
              ),
            ),

            const SizedBox(height: 20),

            if (!otpSent)

              SizedBox(
                width: double.infinity,
                child: purpleButton("Send OTP", sendOtp),
              ),

            if (otpSent) ...[

              otpBox(),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: purpleButton(
                  "Verify OTP",
                      () => verifyOtp(otpController.text),
                ),
              )

            ]

          ],

        ),
      ),
    );
  }
}