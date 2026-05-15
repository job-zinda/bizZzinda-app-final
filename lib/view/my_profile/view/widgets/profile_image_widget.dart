import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/model/profile_model.dart';
import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:biz_zinda/view_model/profile_analytics_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/file_view_model.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? icon;
  final ProfileModel? profileModel;
  const ProfileImageWidget(
      {super.key,  this.icon, required this.profileModel});

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileViewModel>();
    Size size = MediaQuery.of(context).size;
    double coverHeight = size.height * 0.21;
    double profileHeight = 75;
    return buildCoverImage(coverHeight, profileHeight, context);
  }

  Widget buildCoverImage(
    double coverHeight, double profileHeight, BuildContext context) {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(bottom: profileHeight / 1.4),
        child: Stack(
          children: [
            SizedBox(
              height: coverHeight,
              width: double.infinity,
              child: profileModel?.coverImage?.isEmpty ?? true
                  ? Container(
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          "No cover image",
                          style: TextStyle(color: PColors.white),
                        ),
                      ),
                    )
                  : SafeCachedNetworkImage(
                      imageUrl: profileModel?.coverImage,
                      fit: BoxFit.cover,
                    ),
            ),
            if (icon != null)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      String url = await context
                              .read<FileUploadViewModel>()
                              .pickedImageUpload(image, 'Cover') ??
                          '';
                      context.read<ProfileViewModel>().updateCoverImage(url: url);
                    }
                  },
                  icon: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
      Positioned(
        left: 20,
        top: coverHeight - (profileHeight / 1.4),
        child: CircleAvatar(
          radius: profileHeight / 1.4,
          backgroundColor: PColors.white,
          child: CircleAvatar(
            radius: profileHeight / 1.5,
            backgroundImage: (() {
              final imageUrl = profileModel?.profileImageUrl;
              bool isValidUrl = imageUrl != null && imageUrl.isNotEmpty && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
              if (isValidUrl) {
                debugPrint("Attempting to load profile avatar from network: $imageUrl");
                return safeImageProvider(imageUrl, placeholderAsset: PImages.profile);
              } else {
                if (imageUrl != null && imageUrl.isNotEmpty) {
                  debugPrint("Invalid or non-HTTP/HTTPS profile avatar URL ('$imageUrl'), falling back to asset: ${PImages.profile}");
                } else {
                  debugPrint("Profile avatar URL is null or empty, falling back to asset: ${PImages.profile}");
                }
                return AssetImage(PImages.profile) as ImageProvider;
              }
            })(),
            onBackgroundImageError: (exception, stackTrace) {
              // Log the error for debugging if NetworkImage itself fails
              debugPrint("NetworkImage error loading profile avatar: $exception");
              debugPrint("Attempted profile avatar URL: ${profileModel?.profileImageUrl}");
            },
          ),
        ),
      ),
      Positioned(
        top: coverHeight + 10,
        right: 10,
        child: Selector<WrapperViewModel, String>(
          selector: (p0, p1) => p1.viewStatus,
          builder: (context, value, child) => Row(
            children: [
              if (icon != null)
                GestureDetector(
                  onTap: () async {
                    await context
                        .read<ProfileAnalyticsViewModel>()
                        .fetchProfileAnalytics(filter: '7days');
                    context.pushNamed(PPages.profileAnalyticsPageUi);
                  },
                  child: SvgPicture.asset(icon!, height: 30),
                ),
              const SizedBox(width: 10),
              WrapperViewStatus.profile == value
                  ? GestureDetector(
                      onTap: () {
                        context.pushNamed(PPages.helpSupportUi);
                      },
                      child: SvgPicture.asset(PSvgs.help, height: 30),
                    )
                  : Container(),
              WrapperViewStatus.profile == value
                  ? const SizedBox(width: 10)
                  : Container(),
            ],
          ),
        ),
      ),
    ],
  );
}

}
