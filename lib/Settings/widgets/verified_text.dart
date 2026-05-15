import 'package:flutter/material.dart';


/// A reusable widget that shows the [text] followed by a yellow verified tick
/// when [isVerified] is true.  Wrap this around usernames anywhere in the app
/// (profile headers, post cards, search results, etc.).
class VerifiedText extends StatelessWidget {
  final String text;
  final bool isVerified;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final double iconSize;

  const VerifiedText({
    Key? key,
    required this.text,
    required this.isVerified,
    this.style,
    this.maxLines,
    this.iconSize = 16,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
        if (isVerified) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.verified,
            size: iconSize,
            color: const Color(0xFFFFD700), // assuming yellow defined, else Color(0xFFFFD600)
          ),
        ]
      ],
    );
  }
}
