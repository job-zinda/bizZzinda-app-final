import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/view/login_section/otp_verify/view_model/view_model.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpNumberFeild extends StatelessWidget {
  const OtpNumberFeild({super.key});
  Widget otp(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        fieldHeight: 56,
        fieldWidth: 56,
        borderRadius: BorderRadius.circular(0),
        shape: PinCodeFieldShape.box,
        borderWidth: 1,
        inactiveBorderWidth: 1,
        activeColor: PColors.white.withOpacity(0.5),
        selectedColor: PColors.white.withOpacity(0.5),
        activeFillColor: PColors.black,
        inactiveColor: PColors.white.withOpacity(0.5),
      ),
      validator: (val) {
        return null;
      },
      onChanged: (value) {
         context.read<OtpPageViewModel>().otp = value;
      },
      onSaved: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return otp(context);
  }
}
