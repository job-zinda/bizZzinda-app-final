import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';

import 'package:biz_zinda/Settings/widgets/text_widget.dart';

import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/validator.dart';
import 'package:biz_zinda/view/edit_profile/view/widgets/image_edit_section.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  List<String> _skills = [];

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _nameController.text = LoggedInUser.name ?? '';
    _emailController.text = LoggedInUser.email ?? '';
    _numberController.text = LoggedInUser.phoneNumber ?? '';
    _skills = List<String>.from(LoggedInUser.skills ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElavatedTextButton(
        text: 'Save',
        textColor: Color(0xFFFB8C00),
        bgcolor: PColors.white,
        borderRadius: 0,
        borderColor: Color(0xFFFB8C00),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            context.read<ProfileViewModel>().updateNormalProfile(
                name: _nameController.text,
                email: _emailController.text,
                skills: _skills,
                context: context);
          }
        },
      ),
      appBar: AppBar(
        title: textWidget(text: 'Edit Profile',color: Color(0xFFFB8C00), fontweight: FontWeight.w400),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const ImageEditSection(),
                const SizedBox(
                  height: 30,
                ),
                nameTextField(),
                const SizedBox(
                  height: 14,
                ),
                // emailTextField(),
                // SizedBox(
                //   height: 14,
                // ),
                mobileTextField(),
                const SizedBox(height: 14),
                skillField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailTextField() {
    return CustomTextFeild(
        controller: _emailController,
        borderColor: Color(0xFFFB8C00),
        borderRadius: 0,
        filColor: PColors.white,
        textHead: 'Email ID',textColor:Color(0xFFFB8C00) ,
        readOnly: true,
        validation: Validator.email,
        hintText: 'Email ID',);
  }

  Widget nameTextField() {
    return CustomTextFeild(
        controller: _nameController,
        borderRadius: 0,
        borderColor: Color(0xFFFB8C00),
        filColor: PColors.white,
        textHead: 'Name',textColor:Color(0xFFFB8C00) ,
        validation: Validator.text,
        hintText: 'Name');
  }

  Widget mobileTextField() {
    return CustomTextFeild(
      controller: _numberController,
      borderColor: Color(0xFFFB8C00),
      borderRadius: 0,
      filColor: PColors.white,
      textHead: 'Mobile number',textColor:Color(0xFFFB8C00),
      validation: Validator.mobile,
      hintText: 'Mobile number',
      maxLength: 10,
      readOnly: true,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
  Widget skillField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFeild(
          controller: _skillController,
          borderColor: const Color(0xFFFB8C00),
          borderRadius: 0,
          filColor: PColors.white,
          textHead: 'My Products/Servieses',textColor:Color(0xFFFB8C00) ,
          hintText: 'Type Products/Servieses',
          onSubmitted: (val) {
            final skill = val?.trim();
            if (skill != null &&
                skill.isNotEmpty &&
                !_skills.contains(skill)) {
              setState(() {
                _skills.add(skill);
              });
              _skillController.clear();
            }
          },
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _skills.map((skill) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFB8C00),
                ),
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFB8C00),
                ),
              ),
            );
          }).toList(),
        )


      ],
    );
  }

}
