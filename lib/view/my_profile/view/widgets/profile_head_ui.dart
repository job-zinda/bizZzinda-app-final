import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileImageWidget(
          profileModel: widget.profileModel,
          icon: widget.icon,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: contentWidget(context, widget.profileModel),
        ),
      ],
    );
  }

  Widget contentWidget(BuildContext context, ProfileModel? profile) {
    final skills = profile?.skills ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Name & Profession Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerifiedText(
                    text: profile?.name ?? '',
                    isVerified: profile?.isVerified ?? false,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                  ),
                  if ((profile?.profession ?? '').isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      profile!.profession!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),

        // 🔹 Followers & Feedback Stats Card
        Container(
          margin: const EdgeInsets.only(top: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFEDD5)),
          ),
          child: Row(
            children: [
              // Followers Stat
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    final profileViewModel = context.read<ProfileViewModel>();
                    profileViewModel.currentPage = 0;
                    profileViewModel.initFollowersPagination(id: profile?.sId ?? "");

                    context.pushNamed(
                      PPages.followersScreen,
                      pathParameters: {'profileId': profile?.sId ?? ""},
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB8C00).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          size: 18,
                          color: Color(0xFFFB8C00),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${profile?.followersCount ?? 0}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const Text(
                            'Followers',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Vertical Divider
              Container(
                height: 32,
                width: 1,
                color: const Color(0xFFFFEDD5),
              ),

              // Feedback Stat
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    final profileViewModel = context.read<ProfileViewModel>();
                    profileViewModel.currentPage = 0;
                    profileViewModel.initFeedbackPagination(id: profile?.sId ?? "");

                    context.pushNamed(
                      PPages.feedbackScreen,
                      extra: profile?.sId,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB8C00).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xFFFB8C00),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.rating?.toStringAsFixed(1) ?? '0.0',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const Text(
                            'Feedback',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // 🔹 Bio Section
        if ((profile?.bio ?? '').isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            profile!.bio!,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],

        // 🔹 Products & Services Section
        if (skills.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            "Products & Services",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...((showAllSkills ? skills : skills.take(3)).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFEDD5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFFB8C00),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF9A3412),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              })),

              // Show More / Show Less Toggle
              if (skills.length > 3)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showAllSkills = !showAllSkills;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFB8C00), width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          showAllSkills ? "Show Less" : "+ ${skills.length - 3} More",
                          style: const TextStyle(
                            color: Color(0xFFFB8C00),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          showAllSkills ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 16,
                          color: const Color(0xFFFB8C00),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
