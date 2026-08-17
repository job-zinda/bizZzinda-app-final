import 'dart:convert';

import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/api_url.dart';
import '../../add_newuser/view/ui.dart';
import '../../../home_section/home_pages/view/home_screen.dart';
import 'package:go_router/go_router.dart';


class OtpScreen extends StatefulWidget {
  final String email;


  const OtpScreen({
    super.key,
    required this.email,

  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();


  Future<void> sendOtp() async {
    EasyLoading.show(status: "Sending OTP...");

    try {
      final response = await ApiService().post(
        Api.sentOtp,
        {
          "email": widget.email.trim().toLowerCase(),
        },
      );

      EasyLoading.dismiss();
      print("SEND OTP RESPONSE: ${response.data}");

      if (response.data["status"] == true) {
        EasyLoading.showSuccess("OTP sent to ${widget.email}");
      } else {
        EasyLoading.showError(response.data["message"] ?? "Failed to send OTP");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (e is DioException) {
        print("❌ ERROR TYPE: ${e.type}");
        print("❌ MESSAGE: ${e.message}");
        print("❌ RESPONSE: ${e.response?.data}");
      } else {
        print("❌ UNKNOWN ERROR: $e");
      }
      EasyLoading.showError("Error sending OTP");
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      EasyLoading.showError("Enter OTP");
      return;
    }

    EasyLoading.show(status: "Verifying...");

    try {
      final response = await ApiService().post(
        Api.verifyOtp,
        {
          "email": widget.email.trim().toLowerCase(),
          "otp": otpController.text.trim(),
        },
      );

      EasyLoading.dismiss();

      print("VERIFY OTP RESPONSE: ${response.data}");

      if (response.data["status"] == true) {
        final data = response.data["data"];

        final bool isNewUser = data["isNewUser"] == true;


        if (isNewUser) {
          EasyLoading.showSuccess("OTP Verified");

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AddUserPage(
                email: widget.email,
                otp: otpController.text.trim(),
              ),
            ),
          );
        }

        else {
          final tokens = data["tokens"];
          final user = data["user"];

          if (tokens != null && user != null) {
            LoggedInUser.tokenUpdate(tokens);

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("accessToken", LoggedInUser.accessToken ?? "");
            await prefs.setString("refreshToken", LoggedInUser.refreshToken ?? "");
            await prefs.setString("userData", jsonEncode(user));


            EasyLoading.showSuccess("Login Successful");

            if (!mounted) return;
            Navigator.of(context).popUntil((route) => route.isFirst);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.go('/');
            });
          } else {
            EasyLoading.showError("Invalid user data");
          }
        }
      } else {
        EasyLoading.showError(response.data["message"] ?? "Invalid OTP");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("❌ VERIFY ERROR: $e");
      EasyLoading.showError("Verification failed");
    }
  }

  @override
  void initState() {
    super.initState();
    sendOtp(); // 🔥 auto send OTP
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFFB8C00);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text("OTP Verification",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 60,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Verify your email",
              style: TextStyle(
             color: Colors.orange.shade300,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.email,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                letterSpacing: 10,
              ),
              decoration: InputDecoration(
                hintText: "------",
                counterText: "",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify OTP",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("Didn't receive OTP? " ,style: TextStyle(color: Colors.orange.shade300),),
                GestureDetector(
                  onTap: sendOtp,
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
