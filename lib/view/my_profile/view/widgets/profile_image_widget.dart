import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/model/profile_model.dart';
import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:biz_zinda/view_model/profile_analytics_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? icon;
  final ProfileModel? profileModel;

  const ProfileImageWidget({
    super.key,
    this.icon,
    required this.profileModel,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileViewModel>();
    final Size size = MediaQuery.of(context).size;
    final double coverHeight = size.height * 0.19;
    const double avatarRadius = 44.0;

    final String coverUrl = profileModel?.coverImage ?? '';
    final bool hasCoverImage = coverUrl.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 🔹 Cover Banner
        Container(
          margin: const EdgeInsets.only(bottom: avatarRadius * 0.8),
          height: coverHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasCoverImage)
                SafeCachedNetworkImage(
                  imageUrl: coverUrl,
                  fit: BoxFit.cover,
                )
              else
                // Elegant brand gradient background when no cover image is uploaded
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFB8C00), Color(0xFFFFAB40), Color(0xFFFFE0B2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -20,
                        bottom: -40,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Soft subtle bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.25),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 🔹 Profile Avatar
        Positioned(
          left: 20,
          top: coverHeight - (avatarRadius * 1.2),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: SizedBox(
                  width: avatarRadius * 2,
                  height: avatarRadius * 2,
                  child: (() {
                    final imageUrl = profileModel?.profileImageUrl;
                    final bool isValidUrl = imageUrl != null &&
                        imageUrl.isNotEmpty &&
                        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

                    if (isValidUrl) {
                      return SafeCachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholderAsset: PImages.profile,
                      );
                    } else {
                      return Image.asset(
                        PImages.profile,
                        fit: BoxFit.cover,
                      );
                    }
                  })(),
                ),
              ),
            ),
          ),
        ),

        // 🔹 Top-Right Quick Action Buttons (Analytics & Help)
        Positioned(
          top: coverHeight + 10,
          right: 16,
          child: Selector<WrapperViewModel, String>(
            selector: (p0, p1) => p1.viewStatus,
            builder: (context, value, child) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      await context
                          .read<ProfileAnalyticsViewModel>()
                          .fetchProfileAnalytics(filter: '7days');
                      if (context.mounted) {
                        context.pushNamed(PPages.profileAnalyticsPageUi);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(icon!),
                    ),
                  ),
                if (WrapperViewStatus.profile == value) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      context.pushNamed(PPages.helpSupportUi);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(PSvgs.help),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
