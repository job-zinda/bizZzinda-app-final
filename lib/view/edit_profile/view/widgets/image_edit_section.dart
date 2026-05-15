import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view_model/file_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ImageEditSection extends StatelessWidget {
  const ImageEditSection({super.key});

  @override
  Widget build(BuildContext context) {
    final image = LoggedInUser.profilePic;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    return Row(
      children: [
        CircleAvatar(
          radius: 46,
          backgroundColor: PColors.white,
          child: CircleAvatar(
            radius: 44,

            backgroundImage:LoggedInUser.profilePic!.isEmpty?
            AssetImage(PImages.profile) : NetworkImage(LoggedInUser.profilePic ?? ''),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        TextButton(
          onPressed: () async {
            XFile? image =
                await ImagePicker().pickImage(source: ImageSource.gallery);

            if (image != null) {
              String url = await context
                      .read<FileUploadViewModel>()
                      .pickedImageUpload(image, 'DP') ??
                  '';

              profileViewModel.updateProfileImage(url: url);
            }
          },
          child: Row(
            children: [
              const Icon(
                Icons.add,
                color: Color(0xFF8A4FFF),
              ),
              textWidget(text: 'Upload image', color: Color(0xFF8A4FFF),)
            ],
          ),
        )
      ],
    );
  }
}
