import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/Pfonts.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';

class WelcomePageUi extends StatelessWidget {
  WelcomePageUi({super.key});

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFB8C00),// 👈 Purple
        surfaceTintColor: const Color(0xFFFB8C00),
        elevation: 0, // 👈 shadow remove
        leadingWidth: 160,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19.0),
          child: Image.asset(
            PImages.logo3,
            width: 160,
            height: 150,
            fit: BoxFit.contain, // 👈 better than cover
          ),
        ),
      ),

      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Container(
                // height: size.height * 0.4,
                child: Image(
                  image: AssetImage(PImages.welcome),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 28, letterSpacing: 1.5,color: Color(0xFFFB8C00),
                            // color: Colors.black,
                            ),
                        children: [
                          TextSpan(text: 'Where',style: TextStyle(color:  Color(0xFFFB8C00),)),
                          WidgetSpan(
                              child: SizedBox(
                            width: 10,
                          )),
                          TextSpan(
                              text: 'Talent',
                              style: TextStyle(fontWeight: FontWeight.bold,color:  Color(0xFFFB8C00),)),
                          TextSpan(text: '\n'),
                          TextSpan(text: 'Meets'),
                          WidgetSpan(
                              child: SizedBox(
                            width: 10,
                          )),
                          TextSpan(
                              text: 'Opportunity',
                              style: TextStyle(fontWeight: FontWeight.bold,color:  Color(0xFFFB8C00),)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    description(),
                    const SizedBox(
                      height: 50,
                    ),
                    getStartButton(context),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getStartButton(BuildContext context) {
    return CustomElavatedTextButton(
      width: double.infinity,
      bgcolor: PColors.white,
      borderRadius: 18,
      borderColor:  Color(0xFFFB8C00),
      textColor:  Color(0xFFFB8C00),
      text: "Get Started",
      onPressed: () {
        context.replaceNamed(PPages.onboardingScreensUi);
      },
    );
  }

  Widget description() {
    return Text(
      "Biz Zinda is your gateway to finding skilled freelancers and offering your talent to the world. Whether you're a hiring manager or a freelancer, we make connecting easy, efficient, and professional.",
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color:  Color(0xFFFB8C00),
        fontFamily: PFonts.manrope,
      ),
    );
  }
}
