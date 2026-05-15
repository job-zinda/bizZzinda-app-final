import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view/widgets/login_head.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> form_key = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Image.asset(PImages.phone, height: 150),
                    const SizedBox(height: 40),
                    LoginHeadingUi(
                      title: "What’s your phone number ?",
                      description:
                          "We need to make sure you’re you. Please let us know what number to send a code to",
                    ),
                    const SizedBox(height: 20),
                    phonenUmberField(),
                  ],
                ),
              ),
            ),
            button(context),
            const SizedBox(height: 10),
          ],
        ),
      ),),
    );
  }

  Widget phonenUmberField() {
    return Form(
      key: form_key,
      child: Consumer<LoginPhoneNumberViewModel>(
        builder: (context, value, child) => CustomTextFeild(
          controller: value.numberController,
          focusNode: _focusNode,
          keyboardType: TextInputType.phone,
          borderColor: Color(0xFF8A4FFF),
          borderRadius: 18,
          hintText: 'Phone number',
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Text(
              "+91",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          prefixfn: () {},
          onChanged: (val) => value.savePhoneNumber(val!),
          onSubmitted: (val) => value.savePhoneNumber(val!),
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          maxLength: 10,
          validation: (val) {
            if (val == null || val.isEmpty) {
              return "Please enter the phone number";
            }
            if (value.phoneDigitCount != val.length) {
              return "Invalid phone number";
            }
            try {
              int.parse(val);
            } catch (e) {
              return "Invalid phone number";
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
           filColor:PColors.white,
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    var model = context.read<LoginPhoneNumberViewModel>();
    return Selector<LoginPhoneNumberViewModel, bool>(
      selector: (_, vm) => vm.loading,
      builder: (context, isLoading, child) {
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomElavatedTextButton(
                width: double.infinity,
                text: 'Send code',
                onPressed: () {
                  if (form_key.currentState?.validate() ?? false) {
                    form_key.currentState!.save();
                    model.sendCode(context);
                  }
                },
                bgcolor: PColors.white,
                borderRadius: 18,
          borderColor: Color(0xFF8A4FFF),
                textColor: Color(0xFF8A4FFF),
              );
      },
    );
  }
}
