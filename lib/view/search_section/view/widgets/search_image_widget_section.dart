import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';

import '../../../../model/profile_model.dart';

class SearchImageWidgetSectionUi extends StatelessWidget {
final  ProfileModel profileModel;
  const SearchImageWidgetSectionUi({super.key, required this.profileModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double coverHeight = size.height * 0.1;
    double profileHeight = 68;
    return buildCoverImage(coverHeight, profileHeight);
  }

  Widget buildCoverImage(double coverHeight, double profileHeight) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: SizedBox(
                height: coverHeight,width: double.infinity,
                child: Image.network(
                profileModel.coverImage??'',  fit: BoxFit.fill,errorBuilder: (context, error, stackTrace) => Image.asset(PImages.noImage , fit: BoxFit.cover,),
           
                )),
          ),
        ),
        Positioned(
            top: coverHeight - (profileHeight / 1.5),
            child: buildProfileImage(profileHeight))
      ],
    );
  }

  Widget buildProfileImage(double profileHeight) {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: PColors.white,
      child: CircleAvatar(
        radius: profileHeight / 2.1,
        backgroundImage: safeImageProvider(
          profileModel.profileImageUrl,
          placeholderAsset: PImages.profile,
        ),
      ),
    );
  }
}
