
import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';

class LoginHeadingUi extends StatelessWidget {
  String? title;
  String? description;
  LoginHeadingUi({super.key, required this.title, required this.description, });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
            text: title,
            fontsize: 26,
            color: Color(0xFF8A4FFF),
            fontweight: FontWeight.w500),
        const SizedBox(
          height: 10,
        ),
        textWidget(text: description, fontsize: 14, color: Color(0xFF8A4FFF),fontweight: FontWeight.w400)
      ],
    );
  }
}
