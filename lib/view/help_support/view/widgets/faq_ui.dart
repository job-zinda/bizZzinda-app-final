import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqUi extends StatelessWidget {
  const FaqUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          
        CustomElavatedTextButton(
          bgcolor: Colors.purple.shade50,
          textColor: Color(0xFF8A4FFF),
          text: "Faq's",onPressed: (){

           launchUrl(
                  Uri.parse('https://www.joraappfreelancers.com/faq'),
                );
        },)
        
        // Container(
        //     margin: const EdgeInsets.only(left: 17, bottom: 20, top: 20),
        //     child: textWidget(text: "FAQ’s", color: PColors.whiteOff)),
        // Container(
        //   margin: const EdgeInsets.symmetric(horizontal: 10),
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: 10,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       return singleCard();
        //     },
        //   ),
        // )
      ],
    );
  }

  Widget singleCard() {
    return Card(
      color: PColors.black2,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: PColors.white,
          iconColor: PColors.white,
          title: textWidget(
              text: "How do I manage my notifications?", color: PColors.white),
          children: [
            ListTile(
              title: textWidget(
                  text:
                      "To manage notifications, go to Settings, select Notification Settings and customize your preferences.",
                  color: PColors.whiteOff.withOpacity(0.5),
                  fontsize: 13),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
