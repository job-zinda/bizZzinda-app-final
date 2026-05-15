import 'dart:io';
import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/model/logged_in_user.dart';

import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:biz_zinda/view/other_user_profile/view/widgets/profile_rating_section.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:share_plus/share_plus.dart';

class OtherUserProfileButtonUi extends StatefulWidget {
  const OtherUserProfileButtonUi({super.key});

  @override
  State<OtherUserProfileButtonUi> createState() => _OtherUserProfileButtonUiState();
}

class _OtherUserProfileButtonUiState extends State<OtherUserProfileButtonUi> {
  bool showRatingSection = true;
  
  Future<void> _shareUserProfile(BuildContext context, String userId, String userName) async {
    // Construct the direct app link
    final String appLink = 'https://jobzinda.com/profile/$userId';

    // App store links
    const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.jobZinda.customers';
    // TODO: Verify this iOS App Store URL and ID. 'id123456789' is likely a placeholder.
    const String appStoreUrl = 'https://apps.apple.com/app/job-zinda/id123456789'; 

    // Create the shareable message
    final String shareText = "🔍 Discover $userName on Job Zinda!\n\n"
        "👉 Tap the link to view their profile and connect:\n"
        "$appLink\n\n"
        "💼 Find your next opportunity with Job Zinda!\n\n"
        "📱 Get the app:\n"
        "Android: $playStoreUrl\n"
        "iOS: $appStoreUrl";

    try {
      // Show the share dialog
      await Share.share(shareText, subject: 'Check out this profile on Job Zinda!');
      // Optional: Show success message if desired
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Profile link shared!'))
      // );
    } catch (e) {
      // Handle potential errors from the Share.share() method itself
      print('Error sharing profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing profile: ${e.toString()}'))
      );
    }
  }
  bool hasRated = false;
  double? userRating;
  String? userFeedback;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfProfileRated();
    });
  }

  Future<void> _checkIfProfileRated() async {
    final PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);
    if (postViewModel.otherUser?.sId == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final String key = 'rated_${postViewModel.otherUser!.sId}';
    
    if (prefs.containsKey(key)) {
      final String? ratingData = prefs.getString(key);
      if (ratingData != null) {
        final parts = ratingData.split('|');
        if (parts.length >= 1) {
          setState(() {
            hasRated = true;
            userRating = double.tryParse(parts[0]) ?? 0.0;
            userFeedback = parts.length > 1 ? parts[1] : '';
          });
        }
      }
    }
  }

  Future<void> _saveRating(double rating, String feedback) async {
    final PostViewModel postViewModel = Provider.of<PostViewModel>(context, listen: false);
    if (postViewModel.otherUser?.sId == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final String key = 'rated_${postViewModel.otherUser!.sId}';
    
    await prefs.setString(key, '$rating|$feedback');
    
    setState(() {
      hasRated = true;
      userRating = rating;
      userFeedback = feedback;
    });
  }
  
  void _showRatingDialog(BuildContext context, String profileId) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: PColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ProfileRatingSection(
            profileId: profileId,
            onClose: () {
              Navigator.pop(context);
            },
            isRated: hasRated,
            existingRating: userRating,
            existingFeedback: userFeedback,
          ),
        ),
      ),
    ).then((_) {
      // Refresh the rating status after dialog is closed
      _checkIfProfileRated();
    });
  }

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = context.watch<PostViewModel>();
    if (postViewModel.otherUser?.sId == LoggedInUser.id) {
      return const SizedBox();
    }
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              button(
                  btn: postViewModel.isFollowed ? 'Unfollow' : 'Follow',
                  fun: () {
                    if (postViewModel.isFollowed) {
                      postViewModel.unFollowUser();
                    } else {
                      postViewModel.followUser();
                    }
                    postViewModel.isFollowed = !postViewModel.isFollowed;
                  },
                  selected: true),
              const SizedBox(
                width: 6,
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<ChatDetailsViewModel>()
                      .fetchAllMessageProfile(
                      postViewModel.otherUser!.sId.toString());
                  context.pushNamed(PPages.chatDetailsPageui);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // white background
                  foregroundColor: const  Color(0xFFFB8C00),// text color
                  side: BorderSide(color:  Color(0xFFFB8C00),width: 2), // border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // rounded corners
                  ),
                  elevation: 0, // remove shadow
                ),
                child: Text('Send message'),
              ),
              const SizedBox(
                width: 6,
              ),
              // Share button
              Container(
                height: 38,
                width: 45,
                decoration: BoxDecoration(
                  color: PColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color:   Color(0xFFFB8C00),)
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.share,
                    color:   Color(0xFFFB8C00),
                    size: 22,
                  ),
                  onPressed: () {
                    if (postViewModel.otherUser != null) {
                      _shareUserProfile(
                        context,
                        postViewModel.otherUser!.sId ?? '',
                        postViewModel.otherUser!.name ?? 'User',
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        if (showRatingSection && !hasRated && postViewModel.otherUser?.sId != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.purple.shade200, // Job Zinda logo yellow
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color:   Color(0xFFFB8C00),),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Rate me and provide feedback—I'm always looking to improve",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: PColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _showRatingDialog(context, postViewModel.otherUser!.sId!);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:  Color(0xFFFB8C00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Rate Now",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: PColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    setState(() {
                      showRatingSection = false;
                    });
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: const  Color(0xFFFB8C00),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (hasRated && postViewModel.otherUser?.sId != null && showRatingSection)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade100, // Job Zinda logo yellow
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: PColors.textFeildBorderColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Rating",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: PColors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      StarRating(
                        rating: userRating ?? 0,
                        size: 20,
                        color: PColors.yellow,
                        starCount: 5,
                        allowHalfRating: true,
                        onRatingChanged: null,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showRatingDialog(context, postViewModel.otherUser!.sId!);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: PColors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: PColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    setState(() {
                      showRatingSection = false;
                    });
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: PColors.textFeildBorderColor.withOpacity(0.3),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget button(
      {required String btn, required Function()? fun, required bool selected}) {
    return Expanded(
      child: CustomElavatedTextButton(
          height: 38,
          borderRadius: 8,
          fontSize: 13,
          text: btn,
          onPressed: fun,
          bgcolor: selected ? PColors.white : PColors.black2,
          textColor:
              selected ? PColors.black : PColors.whiteOff.withOpacity(0.7)),
    );
  }
}
