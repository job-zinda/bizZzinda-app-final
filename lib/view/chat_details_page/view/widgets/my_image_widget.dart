import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';

class MyChatImageWidget extends StatelessWidget {
  const MyChatImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                border: Border.all(
                  color: PColors.imageBorderColor,
                  width: 3,
                ),
              ),
              height: size.height * 0.3,
              child: Image.asset(PImages.chat_image1),
            ),
            textWidget(
                text: "12:20",
                fontsize: 10,
                color: PColors.whiteOff.withOpacity(0.4))
          ],
        ),
      ],
    );
  }
}
