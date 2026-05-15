import 'package:flutter/material.dart';

Widget textWidget(
    {String? text,
    double? fontsize,
    FontWeight? fontweight,
    Color? color,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines}) {
  return Text(text!,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontweight,
        color: color,
      ));
}
