import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';

class GradientText extends StatelessWidget {
  String text;
  final gradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.bottomRight,
      colors: [
        PColors.grad1,
        PColors.grad2,
      ]);

  GradientText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, shadows: [
          BoxShadow(
              color: PColors.black, spreadRadius: 5, offset: const Offset(1, 1))
        ]),
      ),
    );
  }
}
