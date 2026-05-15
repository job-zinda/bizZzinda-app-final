import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:provider/provider.dart';

class ChatBottomTextfeildSectopn extends StatelessWidget {
  ChatBottomTextfeildSectopn({super.key});


  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    ChatDetailsViewModel chatDetailsViewModel =
        context.read<ChatDetailsViewModel>();
    return TextField(
      controller: chatDetailsViewModel.messageController,
      decoration: inputDecoration(context),
      onChanged: (value) {
        chatDetailsViewModel.updateTextContect(value);
        
      },
    );
  }

  InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide:
            BorderSide(color: Color(0xFF8A4FFF), width: 0.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide:
            BorderSide(color: Color(0xFF8A4FFF), width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide:
            BorderSide(color:Color(0xFF8A4FFF), width: 0.0),
      ),

      hintText: "",
      suffixIcon: suffixIcon(context),
      prefixIcon: prefixIcon(),
      // hintStyle: TextStyle(color: Colors.blue),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Color(0xFF8A4FFF),),
      ),
    );
  }

  Widget prefixIcon() {
    return SizedBox(
      width: 40,
      child: Center(
        child: SvgPicture.asset(
          PSvgs.emoji,
          height: 27,
          color: Color(0xFF8A4FFF),
        ),
      ),
    );
  }

  Widget suffixIcon(BuildContext context) {
    ChatDetailsViewModel chatDetailsViewModel =
        context.read<ChatDetailsViewModel>();
    return Container(
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                getImage(context, ImageSource.gallery);
              },
              child: SvgPicture.asset(
                PSvgs.plus,
                height: 24,
              color:   Color(0xFF8A4FFF),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                getImage(context, ImageSource.camera);
              },
              child: SvgPicture.asset(
                PSvgs.camera,
                height: 21,
                width: 7,
              color:   Color(0xFF8A4FFF),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Future getImage(BuildContext context, ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      String? url = await context
          .read<FileUploadViewModel>()
          .pickedImageUpload(image, 'chat');
      ChatDetailsViewModel chatDetailsViewModel =
          context.read<ChatDetailsViewModel>();
      chatDetailsViewModel.updateImageContect(context, url!);
      // chatDetailsViewModel.selectedUrl = url;
    }
  }
}
