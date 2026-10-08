import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/model/product_view_model.dart';
import 'package:biz_zinda/model/service_view_model.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/my_profile_button.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/profile_head_ui.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/self_gallery_section.dart';
import 'package:biz_zinda/utils/profile_share_helper.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:biz_zinda/view_model/subscription_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<ProfileViewModel>().fetchProfile();
      if (!mounted) return;

      context.read<ProductViewModel>().fetchMyProducts();
      context.read<ServiceViewModel>().fetchMyServices();
      context.read<SubscriptionViewmodel>().fetchPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel profileViewModel =
        context.watch<ProfileViewModel>();

    // Show a loader while the profile is still being fetched
    if (profileViewModel.profileModel == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFB8C00),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFFFB8C00),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 4,
            onSelected: (value) {
              if (value == 'upgrade') {
                context.push(PPages.planListUi);
              } else if (value == 'courses') {
                context.push(PPages.coursePurchaseUi);
              } else if (value == 'share') {
                final userId = profileViewModel.profileModel?.sId ?? '';

                if (userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Unable to share your profile')),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Generating shareable link...')),
                );

                shareProfile(
                  userId: userId,
                  userName: profileViewModel.profileModel?.name,
                  profileImageUrl:
                      profileViewModel.profileModel?.profileImageUrl,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'upgrade',
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium_outlined,
                        color: Color(0xFFFB8C00), size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Upgrade',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'courses',
                child: Row(
                  children: [
                    Icon(Icons.school_outlined,
                        color: Color(0xFFFB8C00), size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Courses',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined,
                        color: Color(0xFFFB8C00), size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Share Profile',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              ProfileHeadUi(
                icon: PSvgs.myProfileAnalytics,
                profileModel: profileViewModel.profileModel,
              ),
              const SizedBox(height: 6),
              const MyProfileButtonUi(),
              const SizedBox(height: 8),
              const SelfGallerySection(),
            ],
          ),
        ),
      ),
    );
  }
}
