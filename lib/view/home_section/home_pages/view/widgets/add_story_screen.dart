import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/utils/validator.dart';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../Settings/widgets/custom_icon_elevated_button.dart';
import '../../../../../model/logged_in_user.dart';
import '../../../../video_player/video_player.dart';

class AddStoryScreen extends StatefulWidget {
  static const route = '/add-story-screen';
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String value = 'Anyone';
  @override
  Widget build(BuildContext context) {
    StoryViewModel storyViewModel = context.watch<StoryViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
          child: CustomIconElevatedButton(
              bgcolor: PColors.black2.withOpacity(0.9),
              textColor: PColors.whiteOff.withOpacity(0.6),
              text: 'Upload media',
              borderRadius: 1,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: PColors.seed2,
                  builder: (ctx) {
                    return SizedBox(
                      width: 360,
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: PColors.white,
                                    )),
                              ],
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(ctx);
                                getImage(ImageSource.camera);
                              },
                              leading: Icon(Icons.camera, color: PColors.white),
                              title: textWidget(
                                  text: 'Camera', color: PColors.white),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(ctx);
                                getImage(ImageSource.gallery);
                              },
                              leading: Icon(Icons.photo, color: PColors.white),
                              title: textWidget(
                                  text: 'Gallery', color: PColors.white),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(ctx);
                                _pickVideo(context);
                              },
                              leading: Icon(Icons.videocam_rounded,
                                  color: PColors.white),
                              title: textWidget(
                                  text: 'Video', color: PColors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                //      showBottomSheet(
                //   shape: const BeveledRectangleBorder(),
                //   backgroundColor: PColors.seed2,
                //   context: context,
                //   builder: (context) => sheet(),
                // );
                // getImage(ImageSource.gallery);
                // showBottomSheet(
                //   shape: BeveledRectangleBorder(),
                //   backgroundColor: PColors.seed2,
                //   context: context,
                //   builder: (ctx) => Column(children: [],)
                // );
              },
              icon: Image.asset(
                PImages.photo,
                color: PColors.whiteOff.withOpacity(0.9),
              )),
        ),
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
                // title: Container(
                //   width: 100.0,
                //   child: ButtonTheme(
                //     alignedDropdown: true,
                //     child: DropdownButton<String>(
                //       isDense: true,
                //       dropdownColor: PColors.black2,
                //       value: value,
                //       // isExpanded: true,
                //       style: TextStyle(color: PColors.whiteOff),
                //       icon: Icon(
                //         Icons.keyboard_arrow_down,
                //         color: PColors.whiteOff,
                //       ),
                //       underline: const SizedBox(),
                //       items:
                //           <String>['Anyone', 'Followers'].map((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(
                //             value,
                //             style: TextStyle(color: PColors.whiteOff),
                //           ),
                //         );
                //       }).toList(),
                //       onChanged: (val) {
                //         setState(() {
                //           value = val!;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                trailing: InkWell(
                  onTap: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (storyViewModel.selectedUrl == null) {
                        EasyLoading.showError('Please select media');
                      } else {
                        context.read<StoryViewModel>().createStory(
                            url: storyViewModel.selectedUrl ?? '',
                            description: _descriptionController.text,
                            archived: false,
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
                          color: PColors.black,
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
                    borderColor: PColors.black,
                    hintText: 'Share your thoughts',
                    validation: Validator.text,
                    filColor: PColors.black),
              ),
              const SizedBox(height: 10),
              if (storyViewModel.selectedUrl != null &&
                  storyViewModel.selectedMediaType == 'image')
                Image.network(storyViewModel.selectedUrl!, fit: BoxFit.cover),
              if (storyViewModel.selectedThumbanilFile != null &&
                  storyViewModel.selectedMediaType == 'video')
                InkWell(
                    onTap: () {
                      print("storyv---${storyViewModel.selectedUrl}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoViewScreen(
                                  videoUrl:
                                      storyViewModel.selectedUrl.toString())));
                    },
                    child: Image.memory(
                      storyViewModel.selectedThumbanilFile!,
                      width: 400,
                      height: 500,
                      fit: BoxFit.fill,
                    )),
              const SizedBox(
                height: 20,
              )
              // Column(
              //   children: [

              //
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _generateThumbnail(String videoPath) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.PNG,

      // maxWidth:
      //     128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return thumbnailPath;
  }

  void _pickVideo(BuildContext context) async {
    var result = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    EasyLoading.show();
    if (result != null) {
      StoryViewModel storyViewModel = context.read<StoryViewModel>();

      Uint8List thumbnailPath = await _generateThumbnail(result.path);
      setState(() {
        storyViewModel.selectedThumbanilFile = thumbnailPath;
      });
    
      FileUploadViewModel provider = context.read<FileUploadViewModel>();
      XFile xfile = await createTempXFile(thumbnailPath, 'thumbnail.png');

      storyViewModel.selectedThumbnailUrl =
          await provider.pickedImageUpload(xfile, "thumbnail");
      storyViewModel.selectedMediaType = 'video';
      print("thummm------${storyViewModel.selectedThumbnailUrl}");
      storyViewModel.selectedUrl = await provider.pickedVideoUpload(
          await File(result.path).readAsBytes(), result.path.split('/').last);

      EasyLoading.dismiss();
      print("dnsdnms------${storyViewModel.selectedUrl}");
    } else {
      debugPrint('No file was picked');
    }
  }

  Future<XFile> createTempXFile(Uint8List data, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(data);

    return XFile(tempFile.path);
  }

  Future getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 50, // Compress image to reduce size
        maxWidth: 800, // Resize for better performance
        maxHeight: 800,
      );
    // final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      String? imageUrl = await context
          .read<FileUploadViewModel>()
          .pickedImageUpload(image, 'Story');
      StoryViewModel storyViewModel = context.read<StoryViewModel>();
      storyViewModel.selectedMediaType = 'image';
      storyViewModel.selectedUrl = imageUrl;
    }
  }

  // Future<void> getImage(ImageSource source) async {
  //   try {
  //     // Close the bottom sheet before capturing
  //     // Navigator.pop(context);

  //     // Pick the image from the source
  //     final XFile? image = await _picker.pickImage(
  //       source: source,
  //       imageQuality: 50, // Compress image to reduce size
  //       maxWidth: 800, // Resize for better performance
  //       maxHeight: 800,
  //     );

  //     if (image != null) {
  //       // Show loading while processing
  //       EasyLoading.show(status: 'Uploading image...');

  //       // Upload the image to your backend or storage
  //       String? url = await navigatorKey.currentContext!
  //           .read<FileUploadViewModel>()
  //           .pickedImageUpload(image, 'Story');

  //       StoryViewModel storyViewModel = navigatorKey.currentContext!.read<StoryViewModel>();
  //       storyViewModel.selectedMediaType = 'image';
  //       storyViewModel.selectedUrl = url;
  //       // Dismiss loading
  //       EasyLoading.dismiss();
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     EasyLoading.showError('Error capturing image: $e');
  //   }
  // }
}
