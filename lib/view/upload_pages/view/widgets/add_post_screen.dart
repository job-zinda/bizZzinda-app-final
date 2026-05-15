import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/validator.dart';
import 'package:biz_zinda/view/upload_pages/view/widgets/upload_button.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';
import '../../../video_player/video_player.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String value = 'Anyone';
  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = context.watch<PostViewModel>();
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
              const SizedBox(
                height: 50,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 10),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: LoggedInUser.profilePic!.isEmpty
                      ? AssetImage(PImages.profile)
                      : NetworkImage(LoggedInUser.profilePic ?? ''),
                ),
                title: SizedBox(
                  width: 100.0,
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      isDense: true,
                      dropdownColor: Colors.white,
                      value: value,
                      // isExpanded: true,
                      style: TextStyle(color: PColors.whiteOff),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFFFB8C00),
                      ),
                      underline: const SizedBox(),
                      items:
                          <String>['Anyone', 'Followers'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Color(0xFFFB8C00),),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          value = val!;
                        });
                      },
                    ),
                  ),
                ),
                trailing: InkWell(
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (postViewModel.selectedUrl == null) {
                        EasyLoading.showError('Please select media');
                      } else {
                      // if (postViewModel.selectedUrl == null) {
                      //   postViewModel.selectedMediaType = "text";
                      // }

                      postViewModel.createPost(
                          description: _descriptionController.text,
                          sharedWith: value,
                          context: context);
                    }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: PColors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 6),
                      child: textWidget(
                          text: 'Post',
                          color: Color(0xFFFB8C00),
                          fontweight: FontWeight.w500,
                          fontsize: 14),
                    ),
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
                    filColor: PColors.white),
              ),
              const SizedBox(height: 10),
              if (postViewModel.selectedUrl != null &&
                  postViewModel.selectedMediaType == 'image')
                Image.network(postViewModel.selectedUrl!, fit: BoxFit.cover),
              if (postViewModel.selectedThumbanilFile != null &&
                  postViewModel.selectedMediaType == 'video')
                InkWell(
                    onTap: () {
                      print("fdnfnjdfn---${postViewModel.selectedUrl}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoViewScreen(
                                  videoUrl:
                                      postViewModel.selectedUrl.toString())));
                    },
                    child: Image.memory(
                      postViewModel.selectedThumbanilFile!,
                      width: 400,
                      height: 500,
                      fit: BoxFit.fill,
                    )),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
