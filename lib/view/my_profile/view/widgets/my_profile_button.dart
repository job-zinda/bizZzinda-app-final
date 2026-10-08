import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MyProfileButtonUi extends StatelessWidget {
  const MyProfileButtonUi({super.key});

  Future<void> _shareUserProfile(
    BuildContext context,
    String userId,
    String userName,
  ) async {
    final String profileUrl = 'https://server2.jobzinda.com/profile/$userId';
    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.biz_zinda.app';

    final String shareText =
        "Discover $userName on Biz Zinda!\n\n"
        "View Profile:\n"
        "$profileUrl\n\n"
        "Download Biz Zinda App:\n"
        "$playStoreUrl";

    await Share.share(
      shareText,
      subject: 'Check out this profile on Biz Zinda!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();
    final isFreelancer =
        (profileViewModel.profileModel?.accountType ?? '').toLowerCase() ==
            'freelancer';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          // 🔹 Edit Profile Button (Primary CTA)
          Expanded(
            flex: isFreelancer ? 10 : 6,
            child: SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<ProfileViewModel>().fetchProfile();
                  context.pushNamed(PPages.freeLancerEditProfileUi);
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB8C00),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),

          // 🔹 Plans Button (if not already premium/freelancer)
          if (!isFreelancer) ...[
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 42,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.pushNamed(PPages.subscriptionPageUi);
                  },
                  icon: const Icon(
                    Icons.workspace_premium_outlined,
                    size: 16,
                    color: Color(0xFFFB8C00),
                  ),
                  label: const Text(
                    "Plans",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFB8C00),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF7ED),
                    side: const BorderSide(color: Color(0xFFFB8C00)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(width: 8),

          // 🔹 Share Button
          Container(
            height: 42,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFB8C00)),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.share_outlined,
                color: Color(0xFFFB8C00),
                size: 20,
              ),
              onPressed: () async {
                if (profileViewModel.profileModel != null) {
                  await _shareUserProfile(
                    context,
                    profileViewModel.profileModel!.sId ?? '',
                    profileViewModel.profileModel!.name ?? 'User',
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cannot share: Profile data not loaded'),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}