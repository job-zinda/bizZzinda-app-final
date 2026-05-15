import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/Pfonts.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';

class OnboardingScreensUi extends StatefulWidget {
  const OnboardingScreensUi({super.key});

  @override
  State<OnboardingScreensUi> createState() => _OnboardingScreensUiState();
}

class _OnboardingScreensUiState extends State<OnboardingScreensUi> {
  PageController controller = PageController();

  int page = 0;
  Widget pages({
    required String title,
    required String title2,
    required String dis,
    required String image,
    required Size size,
  }) {
    var size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            height: size.height * 0.45,
            child: Image(
              image: AssetImage(image),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Center(child: pageIndicator(size)),
        const SizedBox(
          height: 50,
        ),
        columnWidget(title, title2, dis, size),
        const Spacer(),
        getStartButton(),
      ],
    );
  }

  Widget columnWidget(String title, String title2, String desc, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          // textAlign: TextAlign.left,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 28,
            fontFamily: PFonts.manrope,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          title2,
          // textAlign: TextAlign.left,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 28,
            fontFamily: PFonts.manrope,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          desc,
          // textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: PColors.white.withOpacity(1),
            fontFamily: PFonts.manrope,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: PageView(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              page = value;
            });
          },
          children: [
            pages(
                image: PImages.welcome1,
                title: 'Discover the ',
                title2: 'Best Talent',
                dis:
                    'Access a diverse pool of freelancers from all industries.',
                size: size),
            pages(
                image: PImages.welcome2,
                title: 'Secure and Seamless',
                title2: 'Hiring',
                dis: 'Hire with confidence and manage projects efficiently.',
                size: size),
            pages(
                image: PImages.welcome3,
                title: 'Showcase Your',
                title2: 'Skills',
                dis: 'Create an impressive profile to attract more clients. ',
                size: size),
          ],
        ),
      ),
    );
  }

  Widget pageIndicator(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dotsIndicator(size),
      ],
    );
  }

  Widget dotsIndicator(Size size) {
    return Row(
      children: [
        Container(
          width: size.width / 5,
          height: 2,
          decoration: BoxDecoration(color:page==0|| page==1||page==2? PColors.white:PColors.white.withOpacity(0.3)),
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          width: size.width / 5,
          height: 2,
          decoration: BoxDecoration(color: page==1||page==2? PColors.white:PColors.white.withOpacity(0.3)),
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          width: size.width / 5,
          height: 2,
          decoration: BoxDecoration(color:page==2? PColors.white:PColors.white.withOpacity(0.3)),
        ),
      ],
    );
    // return DotsIndicator(
    //   position: page,
    //   dotsCount: 3,
    //   decorator: DotsDecorator(
    //       spacing: const EdgeInsets.only(right: 4),
    //       activeSize: Size(size.width / 5, 1),
    //       shape: RoundedRectangleBorder(),
    //       size: Size(size.width / 5, 1),
    //       activeShape: RoundedRectangleBorder(),
    //       // color: PColors.textGrey,
    //       activeColor: PColors.white),
    // );
  }

  Widget getStartButton() {
    return CustomElavatedTextButton(
      width: double.infinity,
      bgcolor: PColors.white,
      borderColor:  Color(0xFF8A4FFF),
      borderRadius: 18,
      textColor: Color(0xFF8A4FFF),
      text: page == 2 ? "Lets go" : "Next",
      onPressed: () {
        // if (page == 2) {
          context.push(PPages.loginWelcomeScreenUi);} // use push instead of replace
        //  else {
        //   controller.nextPage(
        //       duration: const Duration(milliseconds: 300),
        //       curve: Curves.linear);
        // }
      
    );
  }
}
