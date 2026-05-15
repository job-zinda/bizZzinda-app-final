
import 'package:flutter/material.dart';

import '../until/PText_styles.dart';


class CustomElavatedTextButton extends StatelessWidget {
  const CustomElavatedTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.padverticle,
    this.padhorizondal,
    this.fontSize,
    this.bgcolor,
    this.borderRadius,
    this.textColor,
    this.borderColor,
  });

  final void Function()? onPressed;
  final String text;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? padverticle;
  final double? padhorizondal;
  final Color? bgcolor;
  final double? borderRadius;
  final Color? borderColor;

  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade50,
        foregroundColor: Color(0xFFFB8C00),
        padding: EdgeInsets.symmetric(
            vertical: padverticle ?? 8, horizontal: padhorizondal ?? 16),
        fixedSize: Size(width ?? size.width - 40, height ?? 56),
        maximumSize: Size(width ?? size.width - 40, height ?? 56),
        minimumSize: Size(width ?? size.width - 40, height ?? 56),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFFFB8C00),),
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: PTextStyles.titleMedium.copyWith(
          fontSize: fontSize ?? 16,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
