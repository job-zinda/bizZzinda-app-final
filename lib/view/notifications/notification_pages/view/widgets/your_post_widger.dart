import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';

class YourPostWidgetUi extends StatelessWidget {
  const YourPostWidgetUi({super.key});

  @override
  Widget build(BuildContext context) {
    return postWidget();
  }

  Widget postWidget() {
    return Container(
        // width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: PColors.black2),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 56,
                    width: 50,
                    child: Image.asset(
                      PImages.post_pic,
                      height: 60,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: textWidget(
                      text: "Hello Gz.. Good morning😎don’t forgot to follow",
                      overflow: TextOverflow.ellipsis,
                      color: PColors.whiteOff.withOpacity(0.5),
                      fontsize: 12,
                      maxLines: 2),
                )
              ],
            )));
  }
}