import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view/widgets/login_head.dart';

class LoginSplashUi extends StatelessWidget {
  const LoginSplashUi({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  height: size.height * 0.47,
                  child: Image(
                    image: AssetImage(PImages.login1),
                  ),
                ),
              ),
            ),
            LoginHeadingUi(
              title: "You’re all set up !",
              description:
              "Your profile is ready, and you're just one step away from exploring and connecting with talented freelancers or hiring members.",
              // <-- add this
            ),

            const SizedBox(
              height: 40,
            ),
            CustomElavatedTextButton(
              width: double.infinity,
              borderRadius: 0,
              text: "Great",
              onPressed: () {
                context.goNamed(PPages.loginSplash2Ui);
              },
              bgcolor: PColors.white,
              textColor:Color(0xFFFB8C00),
              borderColor: Color(0xFFFB8C00),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
