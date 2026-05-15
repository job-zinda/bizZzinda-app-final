import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'otpScreen.dart';

class LoginWelcomeScreenUi extends StatefulWidget {
  const LoginWelcomeScreenUi({super.key});

  @override
  State<LoginWelcomeScreenUi> createState() => _LoginWelcomeScreenUiState();
}

class _LoginWelcomeScreenUiState extends State<LoginWelcomeScreenUi> {
  final TextEditingController emailController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFB8C00),// Orange 500 (dark/top)
              Color(0xFFFFB74D), // Orange 300 (light) // Light middle-top
              // Light middle-bottom
              // Bottom Dark Purple
            ],
          ),
        ),// 80% opacity
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 17),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height / 2.1,
                  child: Image.asset(
                    PImages.logo4,
                    height: 100,
                    width: size.width / 1.4,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(
                      text: "Start Your Own Shop",
                      fontsize: 25,
                      fontweight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    SizedBox(height: 8),
                    textWidget(
                      text: "Grow your business by connecting with customers nearby",
                      fontsize: 16,
                      fontweight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Username & Password Button
                CustomElavatedTextButton(
                  width: double.infinity,
                  borderRadius: 18,
                  borderColor: PColors.white,
                  bgcolor: PColors.white,
                  textColor: Colors.black,
                  text: 'Continue with username & password',
                  onPressed: () {
                    context.pushNamed(PPages.usernameLoginUi);
                  },
                ),
                const SizedBox(height: 20),

                // 🔹 Email Field
                CustomElavatedTextButton(
                  width: double.infinity,
                  borderRadius: 18,
                  bgcolor: PColors.white,
                  borderColor: PColors.white,
                  textColor:Colors.black,
                  text: 'Signup or Login  with Email',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        final TextEditingController emailController =
                        TextEditingController();

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Enter your email",
                                style: TextStyle(
                                  color: Color(0xFFFB8C00),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 15),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12, // shadow color
                                      blurRadius: 6,          // softness
                                      offset: Offset(0, 3),   // x,y offset
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Enter email",
                                    filled: true,
                                    fillColor: Colors.orange.shade100, // container already has color
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                ),
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
                                  child: const Text("Send OTP",style: TextStyle(color: Colors.black),),
                                  onPressed: () {
                                    final email = emailController.text.trim();

                                    if (email.isEmpty || !email.contains("@")) {
                                      EasyLoading.showError("Enter valid email");
                                      return;
                                    }

                                    Navigator.pop(context); // close sheet

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtpScreen(
                                          email: email,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),
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

                // Mobile Number Button
                // CustomElavatedTextButton(
                //   width: double.infinity,
                //   borderRadius: 18,
                //   bgcolor: PColors.white,
                //   borderColor: PColors.white,
                //   textColor: const Color(0xFF8A4FFF),
                //   text: 'Continue with mobile number',
                //   onPressed: () {
                //     context.read<LoginPhoneNumberViewModel>().numberController.clear();
                //     Navigator.pushNamed(context, PPages.phoneNumberUi);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}