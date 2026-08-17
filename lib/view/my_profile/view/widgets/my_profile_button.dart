import 'dart:io';
import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';

import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyProfileButtonUi extends StatelessWidget {
  const MyProfileButtonUi({super.key});
  Future<void> _shareUserProfile(
      BuildContext context,
      String userId,
      String userName,
      ) async {
    final String profileUrl =
        'https://server2.jobzinda.com/profile/$userId';

    // final String profileUrl =
    //     'https://bizzinda.com/profile/$userId';

    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.biz_zinda.app';

    final String shareText =
        "🔍 Discover $userName on Biz Zinda!\n\n"
        "👉 View Profile:\n"
        "$profileUrl\n\n"
        "📱 Download Biz Zinda:\n"
        "$playStoreUrl";

    await Share.share(
      shareText,
      subject: 'Check out this profile on Biz Zinda!',
    );
  }
  //
  // Future<void> _shareUserProfile(BuildContext context, String userId, String userName) async {
  //   // [REMOVED] Create an instance of FirebaseDynamicLinkService
  //   // [REMOVED] final FirebaseDynamicLinkService dynamicLinkService = FirebaseDynamicLinkService();
  //   // Show loading indicator
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Generating shareable link...'))
  //   );
  //
  //   // try {
  //     // Generate a Firebase Dynamic Link
  //     // [REMOVED] final String dynamicLink = await dynamicLinkService.createProfileDynamicLink(userId);
  //
  //     // Log the dynamic link for debugging
  //     // print('Sharing profile with Firebase Dynamic Link: $dynamicLink');
  //
  //     // Create a shareable message with user information and the dynamic link
  //
  //     // Fallback to regular sharing if dynamic link fails
  //     final String webUrl = 'https://jobzinda.com/profile/$userId';
  //     const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.jobZinda.customers';
  //     const String appStoreUrl = 'https://apps.apple.com/app/job-zinda/id123456789';
  //
  //     final String fallbackShareText = "🔍 Discover $userName on Job Zinda!\n\n"
  //         "👉 Tap the link to view their profile and connect:\n"
  //         "$webUrl\n\n"
  //         "💼 Find your next opportunity with Job Zinda!\n\n"
  //         "📱 Get the app:\n"
  //         "Android: $playStoreUrl\n"
  //         "iOS: $appStoreUrl";
  //
  //     await Share.share(fallbackShareText, subject: 'Check out this profile on Job Zinda!');
  //   }

  //

  @override
  Widget build(BuildContext context) {
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    
    // Debug print to check if profile data is loaded
    print('MyProfileButtonUi build - Profile data: ${profileViewModel.profileModel != null}');
    // print statement fixed or removed
    print("Plans button visible: ${profileViewModel.profileModel?.accountType}");
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Edit profile button
          Flexible(
            flex: 10,
            child: CustomElavatedTextButton(
              height: 38,
                borderColor: const Color(0xFFFB8C00),
              borderRadius: 8,
              fontSize: 13,
              text: "Edit profile",
              onPressed: () {
                context.read<ProfileViewModel>().fetchProfile();
                context.pushNamed(PPages.freeLancerEditProfileUi);
              },
              bgcolor: PColors.white,
              textColor: Color(0xFFFB8C00),
            ),
          ),
          // Show Plans button when the user does NOT have an active premium subscription.
          // This now covers scenarios where the subscription has expired or accountType is null.
          
          if ((profileViewModel.profileModel?.accountType ?? '').toLowerCase() != 'freelancer') ...[
            const SizedBox(
              width: 6,
            ),
            // Plans button
            Flexible(
              flex: 10,
              child: CustomElavatedTextButton(
                height: 38,
                borderRadius: 8,
                borderColor: const Color(0xFFFB8C00),
                fontSize: 13,
                text: "Plans",
                onPressed: () {
                  context.pushNamed(PPages.subscriptionPageUi);
                },
                bgcolor: PColors.white,
                textColor:Color(0xFFFB8C00),
            ),

            ) ],
          const SizedBox(
            width: 6,
          ),
          // Share button with more prominent styling
          Container(
            height: 38,
            width: 45, // Increased width
            decoration: BoxDecoration(
              color: PColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFFB8C00),)
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.share,
                color:  Color(0xFFFB8C00), // Removed opacity for better visibility
                size: 22, // Slightly larger icon
              ),
              onPressed: () async {
                print('Share button pressed');
                if (profileViewModel.profileModel != null) {
                  print('Sharing profile: ${profileViewModel.profileModel!.sId}');
                  await _shareUserProfile(
                    context,
                    profileViewModel.profileModel!.sId ?? '',
                    profileViewModel.profileModel!.name ?? 'User',
                  );
                } else {
                  print('Cannot share: Profile data is null');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cannot share: Profile data not loaded'))
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget button({required String btn, required Function()? fun, required bool selected}) {
    return CustomElavatedTextButton(
      height: 38,
      borderRadius: 8,
      fontSize: 13,
      text: btn,
      onPressed: fun,
      bgcolor: selected ? PColors.whiteOff : PColors.black2,
      textColor: selected
          ? PColors.black
          : Colors.white,
      borderColor: selected
          ? const  Color(0xFFFB8C00)
          : Colors.transparent,
    );


  }
}