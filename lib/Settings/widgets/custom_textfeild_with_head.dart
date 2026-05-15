import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PText_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextfeildWithHead extends StatefulWidget {
  final String textHead;
  final String hintText;
  final Color filColor;
  final Color textColor;
  final Color? borderColor;
  final int? maxLine;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? borderRadius;
  final double? contentPadVertical;
  final FocusNode? focusNode;
  final Function()? sufixfn;
  final Function()? prefixfn;
  final Function()? onTap;
  final Function(String? val) onSaved;
  final Function(String? val) onChanged;
  final String? Function(String? val)? validation;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextfeildWithHead({
    super.key,
    required this.filColor,
    required this.textHead,
    required this.onSaved,
    required this.onChanged,
    required this.validation,
    required this.hintText,
    this.onTap,
    this.sufixfn,
    this.suffixIcon,
    // this.onSubmit,
    this.keyboardType,
    this.autofillHints,
    this.controller,
    this.prefixIcon,
    this.prefixfn,
    this.textColor = const Color(0xFF1E1E1E),
    // this.enabled = true,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.borderColor,
    this.maxLine,
    this.borderRadius,
    this.contentPadVertical,
  });

  @override
  State<CustomTextfeildWithHead> createState() =>
      _CustomTextfeildWithHeadState();
}

class _CustomTextfeildWithHeadState extends State<CustomTextfeildWithHead> {
  InputDecoration inputDecoration() {
    return InputDecoration(
      // enabled: widget.enabled,
      prefixIcon: widget.prefixIcon != null
          ? GestureDetector(
              onTap: widget.prefixfn!,
              child: widget.prefixIcon!,
            )
          : null,
      suffixIcon: widget.suffixIcon != null
          ? GestureDetector(
              onTap: widget.sufixfn,
              child: widget.suffixIcon,
            )
          : null,
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
          vertical: widget.contentPadVertical ?? 18, horizontal: 30),
      filled: true,
      fillColor: widget.filColor,
      counterText: '',
      hintText: widget.hintText,
      hintStyle: PTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w400),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: widget.borderColor ?? PColors.textFeildBorderColor,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: widget.borderColor ?? PColors.textFeildBorderColor,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
      ),
    );
  }

  Widget customTextFeild(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            onTap: widget.onTap,
            focusNode: widget.focusNode,
            autofillHints: widget.autofillHints,
            controller: widget.controller,
            validator: widget.validation,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            keyboardType: widget.keyboardType,
            cursorColor: Theme.of(context).colorScheme.primary,
            maxLines: widget.maxLine ?? 1,
            // style: Theme.of(context).textTheme.labelLarge,
            autocorrect: true,
            // onFieldSubmitted: widget.onSubmit,
            decoration: inputDecoration(),
          ),
        ),
        Positioned(
          top: 1,
          left: 30,
          child: textHead(),
        )
      ],
    );
  }

  Widget textHead() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      color: widget.filColor,
      child: Text(
        widget.textHead,
        style: TextStyle(
          color: widget.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return customTextFeild(context);
  }
}
