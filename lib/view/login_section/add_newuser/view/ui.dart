import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view/widgets/login_head.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
import 'package:biz_zinda/view/login_section/referal_code/view_model/view_model.dart';
import 'package:biz_zinda/services/auth_username_service.dart';
import 'package:biz_zinda/Data/Network/network_api_service.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class AddUserPage extends StatefulWidget {
  final String email;
  final String otp;

  const AddUserPage({super.key, required this.email, required this.otp});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> form_key = GlobalKey<FormState>();
  bool _obscure = true;

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.data['androidId'] ?? '';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: form_key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),

                      const Icon(
                        Icons.person,
                        size: 150,
                        color: Color(0xFFFB8C00),
                      ),

                      const SizedBox(height: 40),

                      LoginHeadingUi(
                        title: "Create your account",
                        description: "Username and password are required",
                      ),

                      const SizedBox(height: 20),

                      nameField(),
                      const SizedBox(height: 13),

                      usernameField(),
                      const SizedBox(height: 13),

                      passwordField(),
                      const SizedBox(height: 13),

                      confirmPasswordField(),
                      const SizedBox(height: 13),

                      referralField(),
                      const SizedBox(height: 13),

                      phonenUmberField(),
                    ],
                  ),
                ),
              ),
            ),

            button(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // 🔹 Name
  Widget nameField() {
    return CustomTextFeild(
      controller: _nameController,
      hintText: 'Name',
      borderColor: const Color(0xFFFB8C00),
      filColor: PColors.white,
      validation: (val) =>
      val == null || val.isEmpty ? "Enter name" : null,
    );
  }

  // 🔹 Username
  Widget usernameField() {
    return CustomTextFeild(
      controller: _usernameController,
      hintText: 'Username',
      borderColor: const Color(0xFFFB8C00),
      filColor: PColors.white,
      validation: (val) {
        if (val == null || val.trim().isEmpty) return 'Enter username';
        if (!RegExp(r'^[A-Za-z0-9._-]{3,30}$').hasMatch(val.trim())) {
          return 'Invalid username';
        }
        return null;
      },
    );
  }

  // 🔹 Password
  Widget passwordField() {
    return CustomTextFeild(
      controller: _passwordController,
      hintText: 'Password',
      borderColor: const Color(0xFFFB8C00),
      filColor: PColors.white,
      obscureText: _obscure,
      suffixIcon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
      sufixfn: () => setState(() => _obscure = !_obscure),
      validation: (val) {
        if (val == null || val.isEmpty) return 'Enter password';
        if (val.length < 8) return 'Min 8 characters';
        return null;
      },
    );
  }

  // 🔹 Confirm Password
  Widget confirmPasswordField() {
    return CustomTextFeild(
      controller: _confirmPasswordController,
      hintText: 'Confirm password',
      borderColor: const Color(0xFFFB8C00),
      filColor: PColors.white,
      obscureText: true,
      validation: (val) {
        if (val != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  // 🔹 Referral
  Widget referralField() {
    return Consumer<AddReferalViewModel>(
      builder: (context, vm, child) => CustomTextFeild(
        controller: vm.referalController,
        hintText: 'Referral code (optional)',
        borderColor: const Color(0xFFFB8C00),
        filColor: PColors.white,
        onChanged: (val) => vm.referralCode = val,
      ),
    );
  }

  // 🔹 Phone
  Widget phonenUmberField() {
    return Consumer<LoginPhoneNumberViewModel>(
      builder: (context, value, child) => CustomTextFeild(
        controller: value.numberController,
        hintText: 'Phone number',
        borderColor: const Color(0xFFFB8C00),
        filColor: PColors.white,
        maxLength: 10,
        prefixIcon: const Padding(
          padding: EdgeInsets.all(12),
          child: Text("+91"),
        ),
        validation: (val) =>
        val == null || val.length != 10 ? "Invalid phone" : null,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (val) => value.savePhoneNumber(val!),
      ),
    );
  }

  // 🔥 Register Button
  Widget button() {
    var model = context.read<AddReferalViewModel>();

    return CustomElavatedTextButton(
      width: double.infinity,
      text: 'Register',
      onPressed: () async {
        if (!(form_key.currentState?.validate() ?? false)) return;

        EasyLoading.show(status: "Creating account...");

        try {
          String deviceId = await getDeviceId();
          final auth = AuthUsernameService(NetworkApiService());

          final resp = await auth.registerWithUsername(
            name: _nameController.text.trim(),
            countryCode: "+91",
            mobileNumber: context
                .read<LoginPhoneNumberViewModel>()
                .numberController
                .text
                .trim(),
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
            email: widget.email,
            deviceId: deviceId,
            referralCode: model.referralCode,
          );

          final data = resp['data'];
          LoggedInUser.login(data);

          if (!mounted) return;
          context.goNamed(PPages.loginSplashUi);

        } catch (e) {
          EasyLoading.showError(e.toString());
        } finally {
          EasyLoading.dismiss();
        }
      },
      bgcolor: Colors.orange.shade50,
      borderRadius: 18,
      borderColor: const Color(0xFFFB8C00),
      textColor: const Color(0xFFFB8C00),
    );
  }
}