import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/view/login_section/otp_verify/view_model/view_model.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
import 'package:provider/provider.dart';

class OtpButtonsUi extends StatelessWidget {
  const OtpButtonsUi({super.key});

  @override
  Widget build(BuildContext context) {
    return buttons(context);
  }

  Widget buttons(BuildContext context) {
    var model = context.read<OtpPageViewModel>();

    return Column(
      children: [
        CustomElavatedTextButton(
            width: double.infinity,
            bgcolor: PColors.black2,
            text: 'Resend code',
            textColor: PColors.white,
            onPressed: () {
              context.read<LoginPhoneNumberViewModel>().sendCode(context);
              // Navigator.pop(context);
            },
            borderRadius: 0),
        const SizedBox(
          height: 10,
        ),
        Selector<OtpPageViewModel, bool>(
          selector: (p0, p1) => p1.loading,
          builder: (context, value, child) {
            if (value) {
              return Center(
                child: CircularProgressIndicator(
                  color: PColors.white,
                ),
              );
            } else {
              return CustomElavatedTextButton(
                  width: double.infinity,
                  bgcolor: PColors.white,
                  text: 'Verify',
                  textColor: PColors.black,
                  onPressed: () {
                    model.verifyOtp(context);
                    // Navigator.pushNamed(context, PPages.loginSplashUi);
                  },
                  borderRadius: 0);
            }
          },
        ),
      ],
    );
  }
}
