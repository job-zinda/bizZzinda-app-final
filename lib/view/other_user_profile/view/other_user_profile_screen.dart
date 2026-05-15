import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';

import 'package:biz_zinda/view/my_profile/view/widgets/gallery_section.dart';
import 'package:biz_zinda/view/other_user_profile/view/widgets/other_user_profile_button.dart';
import 'package:biz_zinda/view/other_user_profile/view/widgets/review_widget.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

import '../../my_profile/view/widgets/other_user_profile_head_ui.dart';
import 'package:biz_zinda/Settings/widgets/loadingBar.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/self_gallery_section.dart';
import 'package:biz_zinda/model/product_view_model.dart';
import 'package:biz_zinda/model/service_view_model.dart';


class OtherUserProfileScreen extends StatefulWidget {
  final String? userId;
  const OtherUserProfileScreen({super.key, this.userId});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  late Future<bool> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfileDetails();
  }

  @override
  void didUpdateWidget(covariant OtherUserProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userId != oldWidget.userId) {
      setState(() {
        _profileFuture = _fetchProfileDetails();
      });
    }
  }
  Future<bool> _fetchProfileDetails() async {

    if (widget.userId == null ||
        widget.userId!.isEmpty) {

      return false;
    }

    debugPrint(
      'OtherUserProfileScreen: Loading profile for userId: ${widget.userId}',
    );

    final postViewModel =
    Provider.of<PostViewModel>(
      context,
      listen: false,
    );

    final productViewModel =
    Provider.of<ProductViewModel>(
      context,
      listen: false,
    );

    final serviceViewModel =
    Provider.of<ServiceViewModel>(
      context,
      listen: false,
    );

    final profileLoaded =
    await postViewModel
        .fetchOtherUserProfileDetails(
      userID: widget.userId!,
    );

    if (profileLoaded) {

      await Future.wait([

        productViewModel
            .fetchOtherUserProducts(
          widget.userId!,
        ),

        serviceViewModel
            .fetchOtherUserServices(
          widget.userId!,
        ),
      ]);
    }

    return profileLoaded;
  }

  // Future<bool> _fetchProfileDetails() {
  //   if (widget.userId == null || widget.userId!.isEmpty) {
  //     // If userId is invalid, return a future that resolves to false.
  //     return Future.value(false);
  //   }
  //   debugPrint('OtherUserProfileScreen: Loading profile for userId: ${widget.userId}');
  //   final postViewModel = Provider.of<PostViewModel>(context, listen: false);
  //   return postViewModel.fetchOtherUserProfileDetails(userID: widget.userId!);
  // }

  void _retryFetch() {
    setState(() {
      _profileFuture = _fetchProfileDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              PostViewModel postViewModel = context.read<PostViewModel>();
              postViewModel.currentPage = 0;
              postViewModel.postController.refresh();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go('/');
                }
              });
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          Consumer<PostViewModel>(
            builder: (context, value, child) {
              if (value.otherUser == null) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                color: PColors.white,
                onSelected: (val) {
                  if (val == "rating") {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      context: context,
                      builder: (mycontext) => ReviewWidgetui(
                        profileId: value.otherUser?.sId?.toString() ?? '',
                      ),
                    );
                  } else if (val == 'block') {
                    value.blockUser(context, id: value.otherUser?.sId?.toString() ?? '');
                  } else if (val == "unblock") {
                    value.unblockUser(context, id: value.otherUser?.sId?.toString() ?? '');
                  } else if (val == "share") {
                    final userId = value.otherUser?.sId?.toString() ?? '';
                    final userName = value.otherUser?.name ?? 'User';
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating shareable link...'))
                    );
                    final String webUrl = 'https://jobzinda.com/profile/$userId';
                    const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.jobZinda.customers';
                    const String appStoreUrl = 'https://apps.apple.com/app/job-zinda/id123456789';
                    final String fallbackShareText = "🔍 Discover $userName on Job Zinda!\n\n"
                        "👉 Tap the link to view their profile and connect:\n"
                        "$webUrl\n\n"
                        "💼 Find your next opportunity with Job Zinda!\n\n"
                        "📱 Get the app:\n"
                        "Android: $playStoreUrl\n"
                        "iOS: $appStoreUrl";
                    Share.share(fallbackShareText, subject: 'Check out this profile on Job Zinda!');
                  }
                },
                itemBuilder: (BuildContext context) {
                  final bool isBlocked = value.otherUser?.isBlocked ?? false;
                  
                  return [
                    PopupMenuItem(
                      value: isBlocked ? 'unblock' : 'block',
                      child: Text(
                        isBlocked
                            ? 'Unblock User'
                            : 'Block User',
                        style: TextStyle(color: Color(0xFFFB8C00),),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'rating',
                      child: Text(
                        "Rate Profile",
                        style: TextStyle(color: Color(0xFFFB8C00),),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'share',
                      child: Text(
                        "Share Profile",
                        style: TextStyle(color: Color(0xFFFB8C00),),
                      ),
                    ),
                  ];
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingBar.loading(),
            );
          } else if (snapshot.hasError || snapshot.data == false) {
            return Consumer<PostViewModel>(
              builder: (context, postViewModel, _) {
                final errorMsg = postViewModel.otherUserProfileError;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load other profile.', style: TextStyle(color: PColors.white)),
                      if ((snapshot.hasError && snapshot.error != null) || errorMsg != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                          child: Text(
                            errorMsg != null ? 'Error: $errorMsg' : 'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.redAccent, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _retryFetch,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Consumer<PostViewModel>(
                  builder: (context, value, child) {
                    if (value.otherUser == null) {
                      return Center(child: Text('Profile data not available.', style: TextStyle(color:  Color(0xFFFB8C00),)));
                    }
                    final bool isBlocked = value.otherUser?.isBlocked ?? false;
                    
                    return Column(
                      children: [
                        const OtherUserProfileHeadUi(),
                        const SizedBox(height: 5),
                        isBlocked
                            ? Container()
                            : const OtherUserProfileButtonUi(),
                        const SizedBox(height: 5),
                        isBlocked
                            ? Container()
                            // : const GallerySection()

                            : const SelfGallerySection(
                          isOtherUser: true,
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(child: Text('Something went wrong.', style: TextStyle(color:  Color(0xFFFB8C00),)));
          }
        },
      ),
    );
  }
}
