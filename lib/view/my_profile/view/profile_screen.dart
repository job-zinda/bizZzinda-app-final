
import 'package:biz_zinda/model/product_view_model.dart';
import 'package:biz_zinda/model/service_view_model.dart';
import 'package:biz_zinda/view/Shop/shop_view_model.dart';
import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/my_profile_button.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/profile_head_ui.dart';
import 'package:biz_zinda/view/plan_ui/ui.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/utils/profile_share_helper.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:biz_zinda/view_model/subscription_view_model.dart';
import 'package:provider/provider.dart';

import 'widgets/self_gallery_section.dart';
import 'package:biz_zinda/model/product_model.dart';
import 'package:biz_zinda/model/service_model.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool hasShop = false;
  @override
  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<ProfileViewModel>().fetchProfile();

      context.read<ProductViewModel>().fetchMyProducts();
      context.read<ServiceViewModel>().fetchMyServices();
      context.read<SubscriptionViewmodel>().fetchPlans();
    });
  }
  @override
  Widget build(BuildContext context) {
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();

    // Show a loader while the profile is still being fetched
    if (profileViewModel.profileModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // This screen should only be shown for premium/freelancer users
    // Normal users are handled by the route definition in main.dart
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,  color: Color(0xFFFB8C00),),
            onSelected: (value) {
              if (value == 'upgrade') {
                context.push(PPages.planListUi);
              } else if (value == 'courses') {
                context.push(PPages.coursePurchaseUi);
              } else if (value == 'share') {
                final userId = profileViewModel.profileModel?.sId ?? '';

                if (userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to share your profile')),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Generating shareable link...')),
                );

                shareProfile(
                  userId: userId,
                  userName: profileViewModel.profileModel?.name,
                  profileImageUrl: profileViewModel.profileModel?.profileImageUrl,
                );
              }
            },
            itemBuilder: (context) => [
            const  PopupMenuItem<String>(
                value: 'upgrade',
                child: Text('Upgrade',style: TextStyle(color: Color(0xFFFB8C00),)),
              ),
              const PopupMenuItem<String>(
                value: 'courses',
                child: Text('Courses',style: TextStyle(color: Color(0xFFFB8C00),)),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: Text('Share Profile',style: TextStyle(color: Color(0xFFFB8C00),)),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ProfileHeadUi(
                icon: PSvgs.myProfileAnalytics,
                profileModel: profileViewModel.profileModel,
              ),
              const SizedBox(height: 5),
              const MyProfileButtonUi(),
              const SizedBox(height: 5),

              const SelfGallerySection(),
            ],
          ),
        ),
      ),
    );
  }
}
