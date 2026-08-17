// import 'package:biz_zinda/view/Create_My_Offer/offer_veiw_model.dart';
// import 'package:biz_zinda/view/video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:biz_zinda/Settings/until/PColors.dart';
// import 'package:biz_zinda/Settings/until/PImages.dart';
// import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
// import 'package:biz_zinda/Settings/widgets/text_widget.dart';
// import 'package:biz_zinda/model/logged_in_user.dart';
// import 'package:biz_zinda/utils/validator.dart';
// import 'package:biz_zinda/view/upload_pages/view/widgets/upload_button.dart';
// import 'package:provider/provider.dart';
//
// class AddOfferScreen extends StatefulWidget {
//   const AddOfferScreen({super.key});
//
//   @override
//   State<AddOfferScreen> createState() => _AddPostScreenState();
// }
//
// class _AddPostScreenState extends State<AddOfferScreen> {
//   final TextEditingController _descriptionController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   String value = 'Anyone';
//
//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   void _postOffer() {
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//
//     final offerViewModel = context.read<OfferViewModel>();
//
//     offerViewModel.createOffer(
//       description: _descriptionController.text.trim(),
//       context: context,
//       city: '',
//       state: '',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final offerViewModel = context.watch<OfferViewModel>();
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       bottomNavigationBar: Padding(
//         padding: MediaQuery.of(context).viewInsets,
//         child: const UploadButtonUi(),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               const SizedBox(height: 50),
//
//               ListTile(
//                 contentPadding: const EdgeInsets.only(left: 10),
//                 leading: CircleAvatar(
//                   radius: 24,
//                   backgroundImage: (LoggedInUser.profilePic != null &&
//                       LoggedInUser.profilePic!.isNotEmpty)
//                       ? NetworkImage(LoggedInUser.profilePic!)
//                       : AssetImage(PImages.profile) as ImageProvider,
//                 ),
//                 title: SizedBox(
//                   width: 100,
//                   child: DropdownButton<String>(
//                     value: value,
//                     isDense: true,
//                     dropdownColor: Colors.white,
//                     style: const TextStyle(color: Colors.black),
//                     underline: const SizedBox(),
//                     icon: const Icon(
//                       Icons.keyboard_arrow_down,
//                       color: Color(0xFFFB8C00),
//                     ),
//                     items: <String>['Anyone', 'Followers']
//                         .map(
//                           (v) => DropdownMenuItem<String>(
//                         value: v,
//                         child: Text(
//                           v,
//                           style: const TextStyle(
//                             color: Color(0xFFFB8C00),
//                           ),
//                         ),
//                       ),
//                     )
//                         .toList(),
//                     onChanged: (val) {
//                       if (val == null) return;
//                       setState(() {
//                         value = val;
//                       });
//                     },
//                   ),
//                 ),
//                 trailing: InkWell(
//                   onTap: _postOffer,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: PColors.white,
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 6,
//                     ),
//                     child: textWidget(
//                       text: 'Post',
//                       color: const Color(0xFFFB8C00),
//                       fontweight: FontWeight.w500,
//                       fontsize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//
//               Form(
//                 key: _formKey,
//                 child: CustomTextFeild(
//                   controller: _descriptionController,
//                   maxLine: 4,
//                   keyboardType: TextInputType.multiline,
//                   borderColor: const Color(0xFFFB8C00),
//                   hintText: 'Share your thoughts',
//                   validation: Validator.text,
//                   filColor: PColors.white,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Location venda, so state/city dropdowns removed.
//
//               if (offerViewModel.selectedUrl != null &&
//                   offerViewModel.selectedMediaType == 'image')
//                 Image.network(
//                   offerViewModel.selectedUrl!,
//                   fit: BoxFit.cover,
//                 ),
//
//               if (offerViewModel.selectedThumbanilFile != null &&
//                   offerViewModel.selectedMediaType == 'video')
//                 InkWell(
//                   onTap: () {
//                     if (offerViewModel.selectedUrl == null) return;
//
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => VideoViewScreen(
//                           videoUrl: offerViewModel.selectedUrl!,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Image.memory(
//                     offerViewModel.selectedThumbanilFile!,
//                     width: 400,
//                     height: 500,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:biz_zinda/view/Create_My_Offer/offer_veiw_model.dart';
import 'package:biz_zinda/view/video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/validator.dart';
import 'package:biz_zinda/view/upload_pages/view/widgets/upload_button.dart';
import 'package:provider/provider.dart';



class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key});

  @override
  State<AddOfferScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddOfferScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String selectedCity = "Kochi";
  String selectedState = "Kerala";
  final _formKey = GlobalKey<FormState>();
  String value = 'Anyone';

  @override
  Widget build(BuildContext context) {
    // OfferViewModel instance
    OfferViewModel offerViewModel = context.watch<OfferViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const UploadButtonUi(),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 50),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 10),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: (LoggedInUser.profilePic != null &&
                      LoggedInUser.profilePic!.isNotEmpty)
                      ? NetworkImage(LoggedInUser.profilePic!)
                      : AssetImage(PImages.profile) as ImageProvider,
                ),
                title: SizedBox(
                  width: 100.0,
                  child: DropdownButton<String>(
                    value: value,
                    isDense: true,
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    underline: const SizedBox(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFFFB8C00),
                    ),
                    items: <String>['Anyone', 'Followers']
                        .map((v) => DropdownMenuItem<String>(
                      value: v,
                      child: Text(
                        v,
                        style: const TextStyle(color: Color(0xFFFB8C00),),
                      ),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        value = val!;
                      });
                    },
                  ),
                ),
                trailing: InkWell(
                  // Disabled while a create is in flight so the same offer
                  // cannot be posted twice by tapping repeatedly.
                  onTap: offerViewModel.isCreating
                      ? null
                      : () {
                    if (_formKey.currentState?.validate() ?? false) {

                      if (offerViewModel.selectedUrl == null) {
                        EasyLoading.showError('Please select media');
                        return;
                      }


                      if (selectedCity == null || selectedState == null) {
                        EasyLoading.showError("Please select city & state");
                        return;
                      }

                      offerViewModel.createOffer(
                        description: _descriptionController.text,
                        context: context, city: '', state: '',
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: PColors.white,
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                    child: textWidget(
                        text: offerViewModel.isCreating ? 'Posting...' : 'Post',
                        color: offerViewModel.isCreating
                            ? const Color(0x80FB8C00)
                            : const Color(0xFFFB8C00),
                        fontweight: FontWeight.w500,
                        fontsize: 14),
                  ),
                ),
              ),

              Form(
                key: _formKey,
                child: CustomTextFeild(
                  controller: _descriptionController,
                  maxLine: 4,
                  keyboardType: TextInputType.multiline,
                  borderColor: Color(0xFFFB8C00),
                  hintText: 'Share your thoughts',
                  validation: Validator.text,
                  filColor: PColors.white,
                ),
              ),
              const SizedBox(height: 20),


            DropdownButtonFormField<String>(
              value: selectedState,
              decoration: InputDecoration(
                labelText: "Select State",

                // Normal border
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFB8C00),), // normal color
                  borderRadius: BorderRadius.circular(8),
                ),

                // Focus cheyyumbo (click cheyyumbo)
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),

                // Error undenkil
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),

                // Focus + error
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              items: ["Kerala", "Tamil Nadu", "Karnataka"]
                  .map((state) => DropdownMenuItem(
                value: state,
                child: Text(state),
              ))
                  .toList(),

              onChanged: (val) {
                context.read<OfferViewModel>().selectedState = val;
                setState(() {
                  selectedState = val!;
                });
              },
            ),
              const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCity,
              decoration: InputDecoration(
                labelText: "Select Location",

                // Default border
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFB8C00),),
                  borderRadius: BorderRadius.circular(8),
                ),

                // Click / focus cheyyumbo
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),

                // Error state
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),

                // Focus + error
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              items: ["Kochi", "Thrissur", "Calicut", "Trivandrum"]
                  .map((city) => DropdownMenuItem(
                value: city,
                child: Text(city),
              ))
                  .toList(),

              onChanged: (val) {
                context.read<OfferViewModel>().selectedCity = val;
                setState(() {
                  selectedCity = val!;
                });
              },
            ),

              const SizedBox(height: 20),


              if (offerViewModel.selectedUrl != null &&
                  offerViewModel.selectedMediaType == 'image')
                Image.network(offerViewModel.selectedUrl!, fit: BoxFit.cover),


              if (offerViewModel.selectedThumbanilFile != null &&
                  offerViewModel.selectedMediaType == 'video')
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoViewScreen(
                            videoUrl: offerViewModel.selectedUrl!),
                      ),
                    );
                  },
                  child: Image.memory(
                    offerViewModel.selectedThumbanilFile!,
                    width: 400,
                    height: 500,
                    fit: BoxFit.fill,
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
