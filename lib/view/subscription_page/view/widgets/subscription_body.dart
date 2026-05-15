import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';

class SubscriptionBodyUi extends StatelessWidget {
  const SubscriptionBodyUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        singleWidget(
            icon: PSvgs.camera_grad,
            title:
                "Share your projects, images, videos, and status updates to showcase your skills and attract potential clients."),
        const SizedBox(
          height: 20,
        ),
        singleWidget(
            icon: PSvgs.message_grad,
            title:
                "Start conversations and collaborate directly with other freelancers and hiring members."),
        const SizedBox(
          height: 20,
        ),
        singleWidget(
            icon: PSvgs.network,
            title:
                "Expand your network by connecting and interacting with a wider range of freelancers.")
      ],
    );
  }

  Widget singleWidget({required String icon, required String title}) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.only(right: 14), child: SvgPicture.asset(icon)),
        Expanded(
            child: textWidget(
                text: title, color: Color(0xFF8A4FFF),))
      ],
    );
  }
}
