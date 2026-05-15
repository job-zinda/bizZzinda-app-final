import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/icon_more_widget.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/your_post_widger.dart';

class CommentsSingleNotificationwidget extends StatelessWidget {
  const CommentsSingleNotificationwidget({super.key});

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(PImages.pro_pic3),
            ),
            const SizedBox(
              width: 13,
            ),
            Flexible(child: secondColumn()),
            const Column(
              children: [IconMoreWidget()],
            )
          ],
        ),
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
          height: 4,
        ),
        textWidget(text: "5h ", color: PColors.whiteOff.withOpacity(0.6)),
        const SizedBox(
          height: 20,
        ),
        const YourPostWidgetUi(),
        const SizedBox(
          height: 9,
        ),
        likeReplyRow()
      ],
    );
  }

  Widget likeReplyRow() {
    return Row(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              PSvgs.like,
              height: 15,
            ),
            const SizedBox(
              width: 6,
            ),
            textWidget(
                text: "Like",
                color: PColors.whiteOff.withOpacity(0.5),
                fontsize: 13)
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Row(
          children: [
            SvgPicture.asset(PSvgs.reply, height: 15),
            const SizedBox(
              width: 6,
            ),
            textWidget(
                text: "Reply",
                color: PColors.whiteOff.withOpacity(0.5),
                fontsize: 13)
          ],
        ),
      ],
    );
  }

  Widget richTextWidget() {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: const TextSpan(
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500
            // color: Colors.black,
            ),
        children: [
          TextSpan(text: 'James Mathew'),
          WidgetSpan(
              child: SizedBox(
            width: 10,
          )),
          TextSpan(
              text: 'commented',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13)),
          TextSpan(text: ' : '),
          TextSpan(
              text: 'Nice',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13)),
          WidgetSpan(
              child: SizedBox(
            width: 10,
          )),
        ],
      ),
    );
  }
}
