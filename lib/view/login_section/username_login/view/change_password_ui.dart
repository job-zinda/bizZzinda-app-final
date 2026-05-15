import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PText_styles.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/view_model/password_setup_view_model.dart';
import 'package:biz_zinda/services/firebase_id_token.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/repository/repository.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _ccCtrl = TextEditingController(text: '+91');
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  // For init or reset flow
  final _usernameCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool? _hasPassword; // null until status fetched
  bool _codeSent = false;
  bool _otpVerified = false;
  String? _verificationId;
  final _authServices = FirebaseAuthServices();

  @override
  void dispose() {
    _ccCtrl.dispose();
    _phoneCtrl.dispose();
    _usernameCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _otpCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Username is required';
    final re = RegExp(r'^[A-Za-z0-9._-]{3,30}$');
    if (!re.hasMatch(v.trim())) {
      return '3–30 chars, letters/numbers/._-';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    final ok = v.length >= 8 && RegExp(r'[A-Z]').hasMatch(v) && RegExp(r'[0-9]').hasMatch(v);
    if (!ok) return 'Min 8, include uppercase and number';
    return null;
  }

  Future<void> _postOtpFetchStatus() async {
    EasyLoading.show(status: 'Fetching status...');
    try {
      // Ensure ID token is present
      await FirebaseIdTokenProvider.getIdTokenOrThrow();
      final vm = context.read<PasswordSetupViewModel>();
      final status = await vm.getStatus(
        countryCode: _ccCtrl.text.replaceAll('+', ''),
        mobileNumber: _phoneCtrl.text.trim(),
      );
      setState(() {
        _hasPassword = status['hasPassword'] as bool? ?? false;
        final uname = status['username'] as String?;
        if (uname != null && uname.isNotEmpty) {
          _usernameCtrl.text = uname;
        }
      });
    } catch (e) {
      EasyLoading.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _sendCode() async {
    if (_phoneCtrl.text.trim().isEmpty) {
      EasyLoading.showError('Enter mobile number');
      return;
    }
    EasyLoading.show(status: 'Sending code...');
    try {
      final full = '${_ccCtrl.text}${_phoneCtrl.text.trim()}';
      await _authServices.signinWithPhone(
        full,
        verificationFailed: (ex) {
          EasyLoading.showError(ex.message ?? 'Failed to send code');
        },
        codeSent: (verificationId, _) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
          });
          EasyLoading.showSuccess('Code sent');
          // Scroll to reveal OTP input after code is sent
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        },
        onAutoVerify: (user) async {
          setState(() {
            _otpVerified = true;
          });
          await _postOtpFetchStatus();
        },
      );
    } catch (e) {
      EasyLoading.showError('Failed to send code');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null) {
      EasyLoading.showError('No verification session. Send code first.');
      return;
    }
    if (_otpCtrl.text.trim().length < 6) {
      EasyLoading.showError('Enter the 6-digit code');
      return;
    }
    EasyLoading.show(status: 'Verifying code...');
    try {
      final user = await _authServices.verifyOtp(_otpCtrl.text.trim(), _verificationId!);
      if (user == null) throw Exception('Invalid code');
      setState(() {
        _otpVerified = true;
      });
      await _postOtpFetchStatus();
    } catch (e) {
      EasyLoading.showError('Invalid or expired code');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _submitInit() async {
    if (!_formKey.currentState!.validate()) return;
    EasyLoading.show(status: 'Setting password...');
    try {
      final vm = context.read<PasswordSetupViewModel>();
      await vm.initPassword(
        countryCode: _ccCtrl.text.replaceAll('+', ''),
        mobileNumber: _phoneCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
        newPassword: _newPassCtrl.text,
        confirmPassword: _confirmPassCtrl.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(); // back to previous screen
    } catch (e) {
      EasyLoading.showError('Failed to set password');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _submitChange() async {
    if (!_formKey.currentState!.validate()) return;
    EasyLoading.show(status: 'Changing password...');
    try {
      final vm = context.read<PasswordSetupViewModel>();
      await vm.changePassword(
        countryCode: _ccCtrl.text.replaceAll('+', ''),
        mobileNumber: _phoneCtrl.text.trim(),
        newPassword: _newPassCtrl.text,
        confirmPassword: _confirmPassCtrl.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      EasyLoading.showError('Failed to change password');
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            children: [
              Text('Step 1 • Verify your phone with OTP', style: PTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text('Enter your registered phone and verify using code.', style: PTextStyles.titleSmall),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: CustomTextFeild(
                      controller: _ccCtrl,
                      hintText: 'Code',
                      keyboardType: TextInputType.phone,
                      filColor: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFeild(
                      controller: _phoneCtrl,
                      hintText: 'Mobile number',
                      keyboardType: TextInputType.phone,
                      filColor: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!_codeSent) ...[
                CustomElavatedTextButton(
                  text: 'Send code',
                  onPressed: _sendCode,
                  borderRadius: 8,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _codeSent = true; // Manually reveal OTP input if SMS already received
                      });
                      // Ensure OTP field is brought into view
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    },
                    child: const Text('I already have a code'),
                  ),
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter the code we sent', style: PTextStyles.titleSmall),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFeild(
                          controller: _otpCtrl,
                          hintText: '6-digit code',
                          keyboardType: TextInputType.number,
                          filColor: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: 0,
                          borderColor: PColors.textFeildBorderColor,
                          maxLength: 6,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        const SizedBox(height: 12),
                        CustomElavatedTextButton(
                          text: 'Verify code',
                          onPressed: _verifyCode,
                          borderRadius: 8,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              const Divider(height: 32),
              if (_hasPassword == null)
                const SizedBox()
              else if (_hasPassword == false) ...[
                Text('Step 2 • Set username & new password', style: PTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: _validateUsername,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newPassCtrl,
                  decoration: const InputDecoration(labelText: 'New password'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPassCtrl,
                  decoration: const InputDecoration(labelText: 'Confirm new password'),
                  obscureText: true,
                  validator: (v) {
                    final base = _validatePassword(v);
                    if (base != null) return base;
                    if (v != _newPassCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomElavatedTextButton(
                  text: 'Set password',
                  onPressed: _submitInit,
                  borderRadius: 8,
                ),
              ] else ...[
                Text('Step 2 • Set a new password', style: PTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameCtrl,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Username (read-only)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newPassCtrl,
                  decoration: const InputDecoration(labelText: 'New password'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPassCtrl,
                  decoration: const InputDecoration(labelText: 'Confirm new password'),
                  obscureText: true,
                  validator: (v) {
                    final base = _validatePassword(v);
                    if (base != null) return base;
                    if (v != _newPassCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomElavatedTextButton(
                  text: 'Change password',
                  onPressed: _submitChange,
                  borderRadius: 8,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
