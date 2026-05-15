import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view/widgets/login_head.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
import 'package:biz_zinda/view/login_section/referal_code/view_model/view_model.dart';
import 'package:provider/provider.dart';

class ReferalCodeUi extends StatelessWidget {
  const ReferalCodeUi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      PImages.referal,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    LoginHeadingUi(
                        title: "Enter the Referral Code", description: ""),
                    const SizedBox(
                      height: 20,
                    ),
                    referalField(context),
                  ],
                ),
              ),
            ),
            button(context),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
    // return ChangeNotifierProvider(
    //   create: (context) => LoginPhoneNumberViewModel(),
    //   builder: (context, child) {
    //     var model = context.read<LoginPhoneNumberViewModel>();

    //   },
    // );
  }

  Widget referalField(BuildContext context) {
    var model = context.read<AddReferalViewModel>();
    return Form(
        key: model.formKey,
        child: Consumer<AddReferalViewModel>(
          builder: (context, value, child) => CustomTextFeild(
              // controller: value.referalController,
              // keyboardType: TextInputType.,
              borderColor: Color(0xFFFB8C00),
              borderRadius: 18,
              hintText: 'Referral ID',
              // validation: Validator.mobile,

              onSaved: (val) {
                model.referralCode = val;
              },
              onChanged: (val) {
                model.referralCode = val;
              },
              maxLength: 10,
              filColor: PColors.white),
        ));
  }

  Widget button(BuildContext context) {
    var model = context.read<AddReferalViewModel>();

    return Consumer<LoginPhoneNumberViewModel>(
      builder: (context, v, child) => CustomElavatedTextButton(
        width: double.infinity,
        text: 'Continue',
        onPressed: () {
          if (v.signintype == "phone") {
            model.addNewUser(context);
          } else {
            model.addNewUserEmail(
              context,
              v.numberController.text,
              v.countryCodes.first.split('+').last,
            );
          }
        },
        bgcolor: PColors.white,
        borderRadius: 18,
        borderColor: Color(0xFFFB8C00),
        textColor: Color(0xFFFB8C00),
      ),
    );
  }
}
