import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/model/profile_model.dart';

import '../../../../store_location/store_model.dart';

class ResultImageWidgetSectionUi extends StatelessWidget {
  // final ProfileModel profileModel;
  final StoreModel profileModel;
  const ResultImageWidgetSectionUi({super.key, required this.profileModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double coverHeight = size.height * 0.16;
    double profileHeight = 68;
    return buildCoverImage(coverHeight, profileHeight, size.width);
  }

  Widget buildCoverImage(
      double coverHeight, double profileHeight, double width) {
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
                  height: coverHeight,
                  width: double.infinity,
                  child: Image.network(
                    profileModel.coverImage ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      PImages.noImage,
                      fit: BoxFit.cover,
                    ),
                  ))
              // child: Container(
              //     height: coverHeight,
              //     width: width,
              //     color: profileModel.coverImage!.isEmpty?Colors.black:Colors.transparent,
              //     child:profileModel.coverImage!.isEmpty?Container(): Image.network(
              //       profileModel.coverImage!.toString(),
              //       fit: BoxFit.cover,
              //     )),
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
        backgroundImage: profileModel.profileImageUrl!.isEmpty
            ? AssetImage(PImages.profile)
            : NetworkImage(profileModel.profileImageUrl!),
      ),
    );
  }
}
