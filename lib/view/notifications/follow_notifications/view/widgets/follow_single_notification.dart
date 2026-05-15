import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/icon_more_widget.dart';

class FollowSingleNotificationUi extends StatelessWidget {
  const FollowSingleNotificationUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: PColors.whiteOff.withOpacity(0.5)))),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 9.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(PImages.pro_pic3),
            ),
            const SizedBox(
              width: 13,
            ),
            Expanded(child: secondColumn()),
            const Column(
              children: [IconMoreWidget()],
            )
          ],
        ),
      ),
    );
  }

  Widget richTextWidget() {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500
            // color: Colors.black,
            ),
        children: [
          const TextSpan(text: 'James Mathew '),
          const WidgetSpan(
              child: SizedBox(
            width: 10,
          )),
          const TextSpan(
              text: 'Started Following you',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
          const WidgetSpan(
              child: SizedBox(
            width: 10,
          )),
          TextSpan(
              text: '5h',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: PColors.whiteOff.withOpacity(0.4))),
        ],
      ),
    );
  }

  Widget secondColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 11,
        ),
        richTextWidget(),
        const SizedBox(
          height: 20,
        ),
        CustomElavatedTextButton(
          text: "Follow back",
          width: 160,
          height: 35,
          fontSize: 14,
          borderRadius: 3,
          bgcolor: PColors.white,
          onPressed: () {},
          textColor: PColors.black,
        )
      ],
    );
  }
}
