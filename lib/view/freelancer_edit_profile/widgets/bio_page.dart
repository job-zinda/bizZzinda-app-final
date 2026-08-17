import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PText_styles.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/utils/validator.dart';
import 'package:biz_zinda/view/freelancer_edit_profile/widgets/dropdown_widget.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class FreelancerBioPageUi extends StatefulWidget {
  const FreelancerBioPageUi({super.key});

  @override
  State<FreelancerBioPageUi> createState() => _FreelancerBioPageUiState();
}

class _FreelancerBioPageUiState extends State<FreelancerBioPageUi> {
  String? selcetdProfession;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pvm = context.read<ProfileViewModel>();
      pvm.fetchProfession();
      if (pvm.profileModel?.contactNumber != null) {
        pvm.contactNumberController.text = pvm.profileModel!.contactNumber!;
      }
      if (pvm.profileModel?.whatsappNumber != null) {
        pvm.whatsappController.text = pvm.profileModel!.whatsappNumber!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.white,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: CustomElavatedTextButton(
      //   text: 'Finish',
      //   textColor: PColors.black,
      //   bgcolor: PColors.white,
      //   borderRadius: 0,
      //   onPressed: () {
      //     if (_formKey.currentState?.validate() ?? false) {
      //       // context.read<ProfileViewModel>().updateProfile(
      //       //     name: _nameController.text,
      //       //     email: _emailController.text,
      //       //     context: context);
      //     }
      //   },
      // ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: "Create your account",
                    color: Color(0xFF8A4FFF),
                    fontsize: 18,
                    fontweight: FontWeight.bold),
                const SizedBox(
                  height: 30,
                ),
                nameTextField(),
                const SizedBox(
                  height: 14,
                ),
                professionTextField(),
                const SizedBox(
                  height: 14,
                ),
                skillsTextField(),
                const SizedBox(
                  height: 14,
                ),
                bioTextField(),
                const SizedBox(
                  height: 14,
                ),
                // emailTextField(),
                const SizedBox(
                  height: 14,
                ),
                mobileTextField(),
                const SizedBox(
                  height: 14,
                ),
                contactTextField(),
                const SizedBox(
                  height: 14,
                ),
                whatsappTextField(),
                const SizedBox(
                  height: 14,
                ),
                genderWidget(),
                const SizedBox(
                  height: 14,
                ),
                locationField(),
                const SizedBox(
                  height: 14,
                ),
                cityTextField(),
                const SizedBox(
                  height: 14,
                ),
                // stateWidget(),
                stateTextField(),
                const SizedBox(
                  height: 20,
                ),
                CustomElavatedTextButton(
                  width: double.infinity,
                  text: 'Finish',
                  textColor: Color(0xFF8A4FFF),
                  bgcolor: Colors.purple.shade50,
                  borderRadius: 0,
                  borderColor: Color(0xFF8A4FFF),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context
                          .read<ProfileViewModel>()
                          .updateFreelancerProfile(context: context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bioTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
          controller: value.bioController,
          borderColor: Color(0xFF8A4FFF),
          borderRadius: 0,
          filColor: PColors.white,
          textHead: 'Bio *',textColor: Color(0xFF8A4FFF),
          validation: Validator.text,
          hintText: 'Bio'),
    );
  }

  Widget cityTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
          controller: value.cityController,
          borderColor: Color(0xFF8A4FFF),
          borderRadius: 0,
          filColor: PColors.white,
          textHead: 'District ',textColor: Color(0xFF8A4FFF),
          validation: Validator.text,
          hintText: 'District'),
    );
  }

  Widget professionTextField() {
    return Consumer<ProfileViewModel>(
        builder: (context, value, child) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Catagory",
                  style: PTextStyles.titleSmall
                      .copyWith(color: Color(0xFF8A4FFF),),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownWidgetUi(
                  selected: value.professionList.any((profession) =>
                          profession.sId == value.selectedProfessionId)
                      ? value.selectedProfessionId
                      : null,
                  hinttext: "Select Catagory",
                  list: value.professionList,
                  type: "Catagory",
                ),
              ],
            ));
  }

  // Widget stateWidget() {
  //   return Consumer<ProfileViewModel>(
  //       builder: (context, value, child) => Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "State",
  //                 style: PTextStyles.titleSmall
  //                     .copyWith(color: PColors.whiteOff.withOpacity(0.6)),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               StateDropdownWidgetUi(
  //                 // selected: value.isEdit ? value.selectedState : selectedState,
  //                   selected: value.stateList.any((e) =>
  //                         e== value.selectedState)
  //                     ? value.selectedProfessionId
  //                     : null,
  //                 hinttext: "Select State",
  //                 list: value.stateList,
  //                 type: "state",
  //               ),
  //             ],
  //           ));
  // }
  Widget stateTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
          controller: value.stateController,
          borderColor: Color(0xFF8A4FFF),
          borderRadius: 0,
          filColor: PColors.white,
          readOnly: true,
          textHead: 'State',textColor: Color(0xFF8A4FFF),
          // validation: Validator.email,
          hintText: 'select state'),
    );
  }

  Widget emailTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
          controller: value.emailController,
          borderColor: Color(0xFF8A4FFF),
          borderRadius: 0,
          filColor: PColors.white,
          readOnly: true,
          textHead: 'Email ID *',textColor: Color(0xFF8A4FFF),
          // validation: Validator.email,
          hintText: 'Email ID'),
    );
  }

  Widget locationField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
          onTap: () {
            print("sfndf");
            context.pushNamed(PPages.searchLocation, extra: "bio");
          },
          readOnly: true,
          controller: value.addressController,
          borderColor: Color(0xFF8A4FFF),
          borderRadius: 0,
          filColor: PColors.white,
          textHead: 'Location *',textColor: Color(0xFF8A4FFF),
          validation: Validator.text,
          hintText: 'Location'),
    );
  }

  Widget nameTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
          controller: value.nameController,
          borderRadius: 0,
          borderColor: Color(0xFF8A4FFF),
          filColor: PColors.white,
          textHead: 'Shop Name *',textColor: Color(0xFF8A4FFF),
          validation: Validator.text,
          hintText: 'Shope Name'),
    );
  }

  Widget mobileTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
        controller: value.phoneController,
        borderColor: Color(0xFF8A4FFF),
        borderRadius: 0,
        filColor: PColors.white,
        textHead: 'Mobile number',textColor: Color(0xFF8A4FFF),
        validation: Validator.mobile,
        hintText: 'Mobile number',
        maxLength: 10,
        readOnly: true,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

  genderWidget() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: PTextStyles.titleSmall
                .copyWith(color: Color(0xFF8A4FFF),),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: value.selectedGender,
                onChanged: (String? val) {
                  setState(() {
                    value.selectedGender = val!;
                  });
                },
              ),
              const Text('Male'),
              const SizedBox(width: 20),
              Radio<String>(
                value: 'Female',
                groupValue: value.selectedGender,
                onChanged: (String? val) {
                  setState(() {
                    value.selectedGender = val!;
                  });
                },
              ),
              const Text('Female'),
            ],
          ),
        ],
      ),
    );
  }
  Widget skillsTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My products/Servieces',
            style: PTextStyles.titleSmall.copyWith(
              color: const Color(0xFF8A4FFF),
            ),
          ),
          const SizedBox(height: 8),

          CustomTextFeild(
            controller: value.skillController,
            borderColor: const Color(0xFF8A4FFF),
            borderRadius: 0,
            filColor: PColors.white,
            hintText: 'Products/Services',
            textInputAction: TextInputAction.done,


            onSubmitted: (text) {
              if (text != null && text.trim().isNotEmpty) {
                value.addSkillFromText(text);
              }
            },

          ),




          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: value.skills.map((skill) {
              return Chip(
                label: Text(skill),
                backgroundColor: Colors.purple.shade50,
                deleteIconColor: const Color(0xFF8A4FFF),
                onDeleted: () => value.removeSkill(skill),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget contactTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
        controller: value.contactNumberController,
        borderColor: const Color(0xFF8A4FFF),
        borderRadius: 0,
        filColor: PColors.white,
        textHead: 'Call Contact Number (optional)',
        textColor: const Color(0xFF8A4FFF),
        hintText: 'Call contact number',
        maxLength: 10,
        keyboardType: TextInputType.phone,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

  Widget whatsappTextField() {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => CustomTextFeild(
        controller: value.whatsappController,
        borderColor: const Color(0xFF8A4FFF),
        borderRadius: 0,
        filColor: PColors.white,
        textHead: 'WhatsApp Number (optional)',
        textColor: const Color(0xFF8A4FFF),
        hintText: 'WhatsApp number',
        maxLength: 10,
        keyboardType: TextInputType.phone,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

}
