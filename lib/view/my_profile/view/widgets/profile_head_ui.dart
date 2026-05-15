import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/profile_model.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/profile_image_widget.dart';
import 'package:biz_zinda/Settings/widgets/verified_text.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ProfileHeadUi extends StatefulWidget {
  final Map? map;
  final String icon;
  final ProfileModel? profileModel;

  const ProfileHeadUi({
    super.key,
    this.map,
    required this.icon,
    this.profileModel,
  });

  @override
  State<ProfileHeadUi> createState() => _ProfileHeadUiState();
}

class _ProfileHeadUiState extends State<ProfileHeadUi> {
  bool showAllSkills = false;

  @override
  Widget build(BuildContext context) {
    log(LoggedInUser.accessToken.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileImageWidget(
          profileModel: widget.profileModel,
          icon: widget.icon,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          child: contentWidget(context, widget.profileModel),
        )
      ],
    );
  }

  Widget contentWidget(BuildContext context, ProfileModel? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 NAME + PROFESSION + FOLLOWERS/FEEDBACK
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// LEFT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerifiedText(
                    text: profile?.name ?? '',
                    isVerified: profile?.isVerified ?? false,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color:  Color(0xFFFB8C00),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  textWidget(
                    text: profile?.profession ?? '',
                    fontsize: 14,
                    fontweight: FontWeight.w300,
                    color: const  Color(0xFFFB8C00),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ProfileViewModel profileViewModel =
                    context.read<ProfileViewModel>();
                    profileViewModel.currentPage = 0;
                    profileViewModel.initFollowersPagination(
                        id: profile!.sId ?? "");

                    context.pushNamed(
                      PPages.followersScreen,
                      pathParameters: {'profileId': profile.sId!},
                    );
                  },
                  child: columnWidget(
                    title: 'Followers',
                    value: '${profile?.followersCount ?? '0'}',
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    ProfileViewModel profileViewModel =
                    context.read<ProfileViewModel>();
                    profileViewModel.currentPage = 0;
                    profileViewModel.initFeedbackPagination(
                        id: profile!.sId ?? "");

                    context.pushNamed(
                      PPages.feedbackScreen,
                      extra: profile.sId,
                    );
                  },
                  child: columnWidget(
                    title: 'Feedback',
                    value:
                    profile?.rating?.toStringAsFixed(1) ?? '0',
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 18),

        /// 🔹 BIO
        textWidget(
          color: const  Color(0xFFFB8C00),
          textAlign: TextAlign.left,
          fontweight: FontWeight.w300,
          text: profile?.bio ?? '',
          fontsize: 13,
        ),

        const SizedBox(height: 18),

        /// 🔹 SKILLS SECTION
        if (profile?.skills?.isNotEmpty == true)
    /// 🔹 SKILLS SECTION
    if (profile?.skills?.isNotEmpty == true)
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

    const Text(
    "My Products/Servieses",
    style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color:  Color(0xFFFB8C00),
    ),
    ),

    const SizedBox(height: 10),

    /// 👇 SKILLS + BUTTON IN SAME COLUMN
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

    /// Skills List
    ...((showAllSkills
    ? profile!.skills!
        : profile!.skills!.take(2))
        .map((skill) {
    return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 8,
    ),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    const  Color(0xFFFB8C00).withOpacity(0.15),
    const  Color(0xFFFB8C00).withOpacity(0.05),
    ],
    ),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
    color: const  Color(0xFFFB8C00).withOpacity(0.15),
    ),
    ),
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    const Icon(
    Icons.star,
    size: 14,
    color:  Color(0xFFFB8C00),
    ),
    const SizedBox(width: 6),
    Text(
    skill,
    style: const TextStyle(
    fontSize: 13,
    color:  Color(0xFFFB8C00),
    fontWeight: FontWeight.w500,
    ),
    ),
    ],
    ),
    ),
    );
    })),

    /// More Button
    if (profile.skills!.length > 2)
      TextButton.icon(
    onPressed: () {
    setState(() {
    showAllSkills = !showAllSkills;
    });
    },
    style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    side:  BorderSide( // 👈 Purple Border
    color:   Color(0xFFFB8C00).withOpacity(0.15),
    width: 1.2,
    ),
    ),
    icon: Icon(
    showAllSkills
    ? Icons.keyboard_arrow_up
        : Icons.keyboard_arrow_down,
    color: const  Color(0xFFFB8C00),
    ),
    label: Text(
    showAllSkills
    ? "Show Less"
        : "+ ${profile.skills!.length - 2} More",
    style: const TextStyle(
    color:  Color(0xFFFB8C00),
    fontWeight: FontWeight.w600,
    fontSize: 13,
    ),
    ),
    ),

    ],
    ),
    ],
    )
    ]
    );

  }

  Widget columnWidget({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        textWidget(
          text: value,
          fontsize: 16,
          fontweight: FontWeight.w500,
        ),
        const SizedBox(height: 4),
        textWidget(
          text: title,
          fontweight: FontWeight.w300,
          fontsize: 14,
          color: const  Color(0xFFFB8C00),
        ),
      ],
    );
  }
}
