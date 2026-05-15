import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PText_styles.dart';
import 'package:biz_zinda/Settings/until/Pfonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class CustomTextFeild extends StatefulWidget {
  final String? textHead;
  final String hintText;
  final Color filColor;
  final Color? hintColor;

  final Color? textColor;
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
  final Function(String? val)? onSaved;
  final Function(String? val)? onSubmitted;

  final Function(String? val)? onChanged;
  final Iterable<String>? autofillHints;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? val)? validation;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool? obscureText;
  final TextInputAction? textInputAction;

  const CustomTextFeild(
      {super.key,
      this.onTap,
      this.textHead,
      required this.hintText,
      this.suffixIcon,
      this.sufixfn,
      this.onSaved,
      this.onSubmitted,
      this.onChanged,
      this.validation,
      this.keyboardType,
      this.hintColor,
      this.autofillHints,
      this.controller,
      required this.filColor,
      this.prefixIcon,
      this.prefixfn,
      this.textColor,
      this.focusNode,
      this.maxLine,
      this.maxLength,
      this.contentPadVertical,
      this.inputFormatters,
      this.borderRadius,
      this.borderColor,
      this.readOnly = false,
      this.obscureText,
      this.textInputAction,});

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  InputDecoration inputDecoration() {
    return InputDecoration(
      prefixIcon: widget.prefixIcon != null
          ? GestureDetector(
              onTap: widget.prefixfn,
              child: widget.prefixIcon!,
            )
          : null,
      suffixIcon: widget.suffixIcon != null
          ? GestureDetector(
              onTap: widget.sufixfn,
              child: widget.suffixIcon!,
            )
          : null,
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
          vertical: widget.contentPadVertical ?? 16, horizontal: 12),
      filled: true,
      fillColor: widget.filColor,
      counterText: '',
      hintText: widget.hintText,
      hintStyle: widget.hintColor != null
          ? PTextStyles.hinttext
          : PTextStyles.titleSmall,
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

  Widget customTextFeild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.textHead != null) textHead(),
        if (widget.textHead != null) const SizedBox(height: 7),
        TextFormField(
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onSubmitted,
          focusNode: widget.focusNode,
          autofillHints: widget.autofillHints,
          controller: widget.controller,
          validator: widget.validation,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          keyboardType: widget.keyboardType,
          cursorColor: Theme.of(context).colorScheme.primary,
          obscureText: widget.obscureText ?? false,
          maxLines: widget.maxLine ?? 1,
          maxLength: widget.maxLength,
          style: TextStyle(
            color: widget.textColor ?? Color(0xFFFB8C00),
            fontSize: 16,
            fontFamily: PFonts.inter,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.30,
          ),
          inputFormatters: widget.inputFormatters ?? [],
          autocorrect: true,
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget textHead() {
    return Text(
      widget.textHead!,
      style: PTextStyles.titleSmall.copyWith(
        color: widget.textColor ?? Color(0xFFFB8C00),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return customTextFeild();
  }
}
