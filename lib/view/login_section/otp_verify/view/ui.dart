import 'package:flutter/material.dart';
import 'package:biz_zinda/view/login_section/otp_verify/view/widgets/otp_butons.dart';
import 'package:biz_zinda/view/login_section/otp_verify/view/widgets/otp_number_field.dart';
import 'package:biz_zinda/view/login_section/otp_verify/view_model/view_model.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view/widgets/login_head.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
import 'package:provider/provider.dart';

class OtpPageUi extends StatelessWidget {
  final LoginPhoneNumberViewModel model;
  const OtpPageUi({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => OtpPageViewModel(model),
      builder: (context, child) {
        return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: Container(
          height: size.height,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  const SizedBox(
                    height: 30,
                  ),
                  LoginHeadingUi(
                    title: "Verify your mobile number",
                    description:
                        "We’ve send you a one time verification code ",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const OtpNumberFeild(),
                ],
              ),),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: const OtpButtonsUi(),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
      },
     
    );
  }
}
