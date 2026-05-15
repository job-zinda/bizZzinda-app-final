import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/Settings/widgets/verified_text.dart';
import 'package:biz_zinda/model/profile_model.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/profile_image_widget.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../view_model/post_view_model.dart';

class OtherUserProfileHeadUi extends StatefulWidget {
  const OtherUserProfileHeadUi({super.key});

  @override
  State<OtherUserProfileHeadUi> createState() =>
      _OtherUserProfileHeadUiState();
}

class _OtherUserProfileHeadUiState
    extends State<OtherUserProfileHeadUi> {

  bool showAllSkills = false;

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel =
    context.watch<PostViewModel>();
    ProfileModel? profileModel =
        postViewModel.otherUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileImageWidget(profileModel: profileModel),
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 17, vertical: 10),
          child: contentWidget(context, profileModel),
        )
      ],
    );
  }

  Widget contentWidget(
      BuildContext context, ProfileModel? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Name + Followers/Feedback
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  VerifiedText(
                    text: profile?.name ?? '',
                    isVerified:
                    profile?.isVerified ?? false,
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
                    color:
                    const  Color(0xFFFB8C00),
                  ),
                ],
              ),
            ),

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
                child:   columnWidget(
                    title: 'Followers',
                    value: '${profile?.followersCount ?? '0'}',
                    color: const Color(0xFFFB8C00),
                  ),
                ),
                // columnWidget(
                //   title: 'Followers',
                //  color: Color(0xFFFB8C00),
                //   value:
                //   '${profile?.followersCount ?? '0'}',
                // ),
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
                      pathParameters: {'profileId': profile.sId!},
                    );
                  },
                  child: columnWidget(
                    title: 'Feedback',
                    value: profile?.rating?.toStringAsFixed(1) ?? '0',
                    color: const Color(0xFFFB8C00),
                  ),
                ),
                // columnWidget(
                //   title: 'Feedback',
                //  color:  Color(0xFFFB8C00),
                //   value: profile?.rating
                //       ?.toStringAsFixed(1) ??
                //       '0',
                // ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// 🔹 Bio
        textWidget(
          color: const  Color(0xFFFB8C00),
          text: profile?.bio ?? '',
          fontsize: 13,
        ),

        const SizedBox(height: 18),

        /// 🔹 Skills Section
        if (profile?.skills?.isNotEmpty == true)
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              const Text(
                "My Products/Servieses",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:  Color(0xFFFB8C00),
                ),
              ),

              const SizedBox(height: 12),

              /// 👇 Show Only 2 or All
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: (showAllSkills
                    ? profile!.skills!
                    : profile!.skills!.take(2))
                    .map((skill) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const  Color(0xFFFB8C00)
                                .withOpacity(0.15),
                            const  Color(0xFFFB8C00)
                                .withOpacity(0.05),
                          ],
                        ),
                        borderRadius:
                        BorderRadius.circular(25),
                        border: Border.all(
                          color:
                          const  Color(0xFFFB8C00)
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color:
                            Color(0xFFFB8C00),
                          ),
                          const SizedBox(
                              width: 6),
                          Text(
                            skill,
                            style:
                            const TextStyle(
                              fontSize: 13,
                              color:  Color(0xFFFB8C00),
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              /// 🔹 Styled More Button
              if (profile!.skills!.length > 2)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showAllSkills =
                        !showAllSkills;
                      });
                    },
                    child: Container(
                      margin:
                      const EdgeInsets.only(
                          top: 5),
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration:
                      BoxDecoration(
                        color: const  Color(0xFFFB8C00)
                            .withOpacity(0.1),
                        borderRadius:
                        BorderRadius.circular(
                            20),
                        border: Border.all(
                          color: const  Color(0xFFFB8C00).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          Text(
                            showAllSkills
                                ? "Show Less"
                                : "+ ${profile.skills!.length - 2} More",
                            style:
                            const TextStyle(
                              fontSize: 13,
                              fontWeight:
                              FontWeight.w600,
                              color:  Color(0xFFFB8C00),
                            ),
                          ),
                          const SizedBox(
                              width: 4),
                          Icon(
                            showAllSkills
                                ? Icons
                                .keyboard_arrow_up
                                : Icons
                                .keyboard_arrow_down,
                            size: 18,
                            color: const  Color(0xFFFB8C00),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget columnWidget({
    required String title,
    required String value,
    required  Color color,
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
          fontsize: 14,
          fontweight: FontWeight.w300,
          color: const  Color(0xFFFB8C00),
        ),
      ],
    );
  }
}
