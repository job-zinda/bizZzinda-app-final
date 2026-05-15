import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';

class HelpBottomsheetUi extends StatelessWidget {
  const HelpBottomsheetUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
                    const SizedBox(width: 10,)
              ],
            ),
            itemWidget(title: "Terms of service", fun: () {}),
            itemWidget(title: "Privacy policy", fun: () {}),
          ],
        ),
      ),
    );
  }

  Widget itemWidget(
      {required String title, required Function()? fun}) {
    return ListTile(
      onTap: fun,
      title: textWidget(text: title,color: PColors.white,fontsize: 15),
    );
  }
}
