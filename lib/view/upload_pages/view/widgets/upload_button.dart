import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_icon_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:biz_zinda/view/Create_My_Offer/offer_veiw_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class UploadButtonUi extends StatefulWidget {
  const UploadButtonUi({super.key});

  @override
  State<UploadButtonUi> createState() => _UploadButtonUiState();
}

class _UploadButtonUiState extends State<UploadButtonUi> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
      child: CustomIconElevatedButton(
          bgcolor:Colors.purple.shade50,
          textColor: Color(0xFFFB8C00),
          text: 'Upload media',
          borderColor:  Color(0xFFFB8C00),
          borderRadius: 1,
          onPressed: () {
            showBottomSheet(
              shape: const BeveledRectangleBorder(),
              backgroundColor: Colors.purple.shade50,
              context: context,
              builder: (context) => sheet(),
            );
          },
          icon: Image.asset(
            PImages.photo,
            color:  Color(0xFFFB8C00),
          )),
    );
  }

  Widget sheet() {
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
                      color: Color(0xFFFB8C00),
                    )),
              ],
            ),
            ListTile(
              onTap: () {
                getImage(ImageSource.camera);
              },
              leading: Icon(
                Icons.camera,
                color: Color(0xFFFB8C00),
              ),
              title: textWidget(
                text: 'Camera',
                color: Color(0xFFFB8C00),
              ),
            ),
            ListTile(
              onTap: () {
                getImage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo, color:  Color(0xFFFB8C00),),
              title: textWidget(text: 'Gallery', color:  Color(0xFFFB8C00),),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);

                _pickVideo(context);
              },
              leading: Icon(Icons.videocam_rounded, color:  Color(0xFFFB8C00),),
              title: textWidget(text: 'Video', color:  Color(0xFFFB8C00),),
            ),
          ],
        ),
      ),
    );
  }

  // Future getImage(ImageSource source) async {
  //   Navigator.pop(context);
  //   final XFile? image = await _picker.pickImage(source: source);

  //   if (image != null) {
  //     String? url = await context
  //         .read<FileUploadViewModel>()
  //         .pickedImageUpload(image, 'Post');
  //     PostViewModel postProvider = context.read<PostViewModel>();
  //     postProvider.selectedMediaType = 'image';
  //     postProvider.selectedUrl = url;
  //   }
  // }
Future<void> getImage(ImageSource source) async {
  try {
    // Close the bottom sheet before capturing
    Navigator.pop(context);

    // Pick the image from the source
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 50, // Compress image to reduce size
      maxWidth: 800,    // Resize for better performance
      maxHeight: 800,
    );

    if (image != null) {
      // Show loading while processing
      EasyLoading.show(status: 'Uploading image...');
      
      // Upload the image to your backend or storage
      String? url = await context
          .read<FileUploadViewModel>()
          .pickedImageUpload(image, 'Post');

      // Update UI with selected image URL
      OfferViewModel offerProvider = context.read<OfferViewModel>();

      offerProvider.selectedMediaType = 'image';
      offerProvider.selectedUrl = url;
      offerProvider.notifyListeners();

      // Dismiss loading
      EasyLoading.dismiss();
    }
  } catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showError('Error capturing image: $e');
  }
}

  void _pickVideo(BuildContext context) async {
    var result = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    EasyLoading.show();
    if (result != null) {
      OfferViewModel offerProvider = context.read<OfferViewModel>();

      Uint8List thumbnailPath = await _generateThumbnail(result.path);
      setState(() {
        offerProvider.selectedThumbanilFile = thumbnailPath;
      });
          // final Uint8List fileBytes = pickedFile.files.first.bytes ?? Uint8List(0);
      FileUploadViewModel provider = context.read<FileUploadViewModel>();
      XFile xfile = await createTempXFile(thumbnailPath, 'thumbnail.png');

      offerProvider.selectedThumbnailUrl =
          await provider.pickedImageUpload(xfile, "thumbnail");
      offerProvider.selectedMediaType = 'video';

      offerProvider.selectedUrl = await provider.pickedVideoUpload(
          await File(result.path).readAsBytes(), result.path.split('/').last);
      await Future.delayed(const Duration(seconds: 5));
      EasyLoading.dismiss();
      print("dnsdnms------${offerProvider.selectedUrl}");
    } else {
      debugPrint('No file was picked');
    }
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

  Future<XFile> createTempXFile(Uint8List data, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(data);

    return XFile(tempFile.path);
  }
}
