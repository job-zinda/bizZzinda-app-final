import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsUi extends StatelessWidget {
  const ContactUsUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 17, bottom: 10, top: 20),
            child: textWidget(text: 'Contact us', color:  Color(0xFF8A4FFF),)),
        contentWidget(
            icon: PSvgs.call,
            title: 'Call',
            onTap: () {
              _makePhoneCall('+919847561998');
            }),
        contentWidget(
            icon: PSvgs.mail,
            title: 'Email',
            onTap: () {
              sendEmail();
            }),
        contentWidget(
            icon: PSvgs.feedback,
            title: 'Send Feedback',
            onTap: () {
              context.pushNamed(PPages.sendFeedbackUi);
            }),
      ],
    );
  }

  Widget contentWidget(
      {required String icon,
      required String title,
      required Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(icon,color: Color(0xFF8A4FFF), ),
      title: textWidget(text: title, color:  Color(0xFF8A4FFF),),
    );
  }
}

Future<void> sendEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'jobzinda@gmail.com',
    query: 'subject=&body=',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch $emailUri';
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
