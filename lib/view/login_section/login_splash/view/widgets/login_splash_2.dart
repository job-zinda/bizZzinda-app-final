import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view/widgets/login_head.dart';

class LoginSplash2Ui extends StatelessWidget {
  const LoginSplash2Ui({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
              onTap: () {
              context.replace('/home');
              },
              child: Icon(
                Icons.close,
                color: PColors.whiteOff.withOpacity(0.5),
              )),
          const SizedBox(
            width: 20,
          )
        ],
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
                    image: AssetImage(PImages.login2),
                  ),
                ),
              ),
            ),
            LoginHeadingUi(
              title: "Don't miss anything",
              description:
                  "Get real-time updates on new freelancer profiles, project milestones, and important messages.\n\nEnable notifications to stay in the loop and seize every opportunity.",
            ),
            const SizedBox(
              height: 40,
            ),
            buttons(context)
          ],
        ),
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Column(
      children: [
        CustomElavatedTextButton(
          width: double.infinity,
          borderRadius: 18,
          text: "Not now",
          onPressed: () {
            context.replace('/home');
          },
          bgcolor: Colors.purple.shade50,
          textColor:   Color(0xFF8A4FFF),
          borderColor: Color(0xFF8A4FFF),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomElavatedTextButton(
          width: double.infinity,
          borderRadius: 18,
          text: "Sure",
          onPressed: () {
            context.replace('/home');
          },
          bgcolor: PColors.white,
          textColor: Color(0xFF8A4FFF),
          borderColor: Color(0xFF8A4FFF),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
