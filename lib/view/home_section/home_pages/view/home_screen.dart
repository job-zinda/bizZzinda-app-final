import 'package:biz_zinda/Terms_and_conditions/TermsAndConditionUi.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/view/Create_My_Offer/OfferSectionWidget.dart';
import 'package:biz_zinda/view/create_my_offer/offermodel.dart';
import 'package:biz_zinda/view/Create_My_Offer/offer_veiw_model.dart';
import 'package:biz_zinda/view/plansforyou/plansforyouUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/banners_veiw_model.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/home_appbar.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/post_section.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/story_section.dart';
import 'package:biz_zinda/view_model/chat_badge_viewmodel.dart';
import 'package:biz_zinda/view_model/notification_view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:biz_zinda/view_model/referal_view_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/home_floating_action.dart';



import 'HomeVideo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  final Color primaryColor = const Color(0xFFFB8C00);
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addObserver(this);
    // _postViewModel = context.read<PostViewModel>();
    // _postViewModel.addListener(_onPostsUpdated);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
      context.read<BannerViewModel>().getBanners();
      context.read<OfferViewModel>().refreshOffer();
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);


  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    // final postViewModel = context.read<PostViewModel>();
    // postViewModel.currentPage = 0;
    // await postViewModel.refreshPosts();

    // Fetch profile data when the screen loads, mirroring the profile screen's behavior.
    context.read<ProfileViewModel>().fetchProfile();
           _showAssistantHint();
  }

  void _onPostsUpdated() {
    // Currently not used, kept for future enhancements.
  }
  Future<void> openWhatsAppGroup() async {

    final Uri url = Uri.parse(
        "https://chat.whatsapp.com/CziCbs0nTjYHXU9kMXhMrW"
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Could not open WhatsApp group";
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _postViewModel?.removeListener(_onPostsUpdated);
        // _postViewModel.removeListener(_onPostsUpdated);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController _scrollController;
  bool _isFabVisible = true;

  void _scrollListener() {
    if (!mounted) return;
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (_isFabVisible) setState(() => _isFabVisible = false);
    } else if (direction == ScrollDirection.forward) {
      if (!_isFabVisible) setState(() => _isFabVisible = true);
    }
  }

  bool _assistantHintVisible = false;
  // Nullable (not `late`): it is never assigned, so reading it in dispose()
  // via `_postViewModel?.` used to throw LateInitializationError during the
  // shell teardown on logout, leaving the element tree half-unmounted.
  PostViewModel? _postViewModel;
  bool _wasPostsLoading = true;

  Future<void> _showAssistantHint() async {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _assistantHintVisible = true;
        });
        // Hide after 4 seconds
        Timer(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _assistantHintVisible = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFFB8C00);
    final bannerVM = Provider.of<BannerViewModel>(context);
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => Scaffold(

        key: scaffoldKey,
        drawer: Drawer(
          backgroundColor: PColors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: primaryColor,),
                child: LoggedInUser.isGuest
                    ? Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.person_outline),
                    ),
                    const SizedBox(width: 10),
                    textWidget(text: 'Guest User', color: Colors.white),
                  ],
                )
                    : value.profileModel == null
                    ? Row(
                  children: [
                    // Skeleton avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Skeleton text
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.grey.shade300,
                    ),
                  ],
                )
                    : Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: (value.profileModel?.profileImageUrl ?? '').isEmpty
                          ? AssetImage(PImages.profile) as ImageProvider
                          : NetworkImage(value.profileModel!.profileImageUrl!),
                    ),
                    const SizedBox(width: 10),
                    textWidget(text: value.profileModel!.name ?? 'Guest User',color: Colors.black,),
                  ],
                ),
              ),
              if (LoggedInUser.isGuest)
                drawerWidget(
                    title: "Login / Sign Up",
                    icon: Icon(Icons.login, color: primaryColor),
                    fun: () {
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          context.go(PPages.loginWelcomeScreenUi);
                        }
                      });
                    }),
              // if (context.read<ProfileViewModel>().profileModel != null &&
              //     (context.read<ProfileViewModel>().profileModel!.profession ?? '')
              //         .toLowerCase()
              //         .trim() ==
              //         'zinda promoter')
              //   drawerWidget(
              //     title: "Plans For You",
              //     icon: const Icon(Icons.workspace_premium, color: Color(0xFF8A4FFF)),
              //     fun: () {
              //       Navigator.of(context, rootNavigator: true).push(
              //         MaterialPageRoute(
              //           builder: (context) => const FreelancerMessagesScreen(),
              //         ),
              //       );
              //
              //
              //
              //     },
              //   )
              // else
              //   drawerWidget(
              //     title: "Task Corner",
              //     icon: const Icon(Icons.task_outlined, color: Color(0xFF8A4FFF)),
              //     fun: () {
              //       Navigator.pop(context);
              //       context.pushNamed(PPages.taskCornerAssignments);
              //     },
              //   ),
              if (!LoggedInUser.isGuest)
                drawerWidget(
                    title: "Wallet",
                    icon: Icon(Icons.account_balance_wallet_outlined, color:  primaryColor,),
                    fun: () {
                      Navigator.pop(context);
                      context.push(PPages.wallet);
                    }),
              // drawerWidget(
              //   title: "Orders",
              //   icon: SvgPicture.asset(
              //     PSvgs.referals,
              //     color: primaryColor,
              //   ),
              //   fun: () {
              //     context.read<ReferalViewModel>().fetchReferlaList(context);
              //     Navigator.pop(context);
              //     context.pushNamed(PPages.referalPageUi);
              //   },
              // ),
              // context.read<ProfileViewModel>().profileModel == null
              //     ? Container()
              //     : context
              //     .read<ProfileViewModel>()
              //     .profileModel!
              //     .accountType!
              //     .toLowerCase() ==
              //     "normal"
              //     ? Container()
              //     : drawerWidget(
              //     title: "Orders",
              //     icon: SvgPicture.asset(PSvgs.referals,color: Color(0xFF8A4FFF),),
              //     fun: () {
              //       context
              //           .read<ReferalViewModel>()
              //           .fetchReferlaList(context);
              //       Navigator.pop(context);
              //       context.pushNamed(PPages.referalPageUi);
              //     }),
              // context.read<ProfileViewModel>().profileModel == null
              //     ? Container()
              //     : context
              //                 .read<ProfileViewModel>()
              //                 .profileModel!
              //                 .accountType!
              //                 .toLowerCase() ==
              //             "normal"
              //         ? Container()
              //         : drawerWidget(
              //             title: "Coins",
              //             icon: SvgPicture.asset(PSvgs.coins,color: Color(0xFF8A4FFF),),
              //             fun: () {
              //               Navigator.pop(context);
              //               context.pushNamed(PPages.coinScreenUi);
              //             }),
              drawerWidget(
                  title: "Contact",
                  icon: Icon(
                    Icons.call,
                    color: primaryColor,
                    size: 18,
                  ),
                  fun: () {
                    _makePhoneCall('+919847561998');
                  }),
              drawerWidget(
                title: "Terms and Conditions",
                icon: SvgPicture.asset(
                  PSvgs.terms,
                  color: primaryColor,
                ),
                fun: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  TermsConditionsPage(),
                    ),
                  );
                },
              ),
              drawerWidget(
                  title: "Privacy Policy",
                  icon: SvgPicture.asset(PSvgs.privacy_policy,
                    color: primaryColor,),
                  fun: () {
                    launchUrl(
                      Uri.parse(
                          'https://www.joraappfreelancers.com/privacy-policy'),
                    );
                  }),
              drawerWidget(
                  title: "Help and Support",
                  icon: SvgPicture.asset(PSvgs.support,color: primaryColor),
                  fun: () {
                    Navigator.pop(context);
                    context.pushNamed(PPages.helpSupportUi);
                  }),
              if (!LoggedInUser.isGuest)
                drawerWidget(
                    title: "Delete account",
                    icon: Icon(
                      Icons.delete,
                      color: primaryColor,
                      size: 18,
                    ),
                    fun: () {
                      showDialog(
                        context: context,
                        builder: (context) => logoutBox(
                            context: context,
                            title: "Do you want to delete your account?",
                            onTap: () {
                              context
                                  .read<ProfileViewModel>()
                                  .deleteProfile(context);
                            }),
                      );
                    }),
              if (!LoggedInUser.isGuest)
                drawerWidget(
                    title: "Logout",
                    icon: Icon(
                      Icons.logout,
                      color: PColors.red,
                      size: 18,
                    ),
                    fun: () {
                      showDialog(
                        context: context,
                        builder: (context) => logoutBox(
                            context: context,
                            title: "Do you want to logout?",
                            onTap: () {
                              context
                                  .read<ProfileViewModel>()
                                  .userLogout(context);
                            }),
                      );
                    }),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: HomeAppbar(
            scaffoldKey: scaffoldKey,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15),
          child: Stack(
            children: [
              // SingleChildScrollView(
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(horizontal: 10),
              //     child: Column(
              //       children: [
              //         const StorySection(),
              //         Divider(
              //           color: PColors.whiteOff.withOpacity(0.3),
              //         ),
              //         const PostSection(),
              //         const SizedBox(height: 100),
              //       ],
              //     ),
              //   ),
              // ),
              RefreshIndicator(
                onRefresh: () async {
                  // await context.read<PostViewModel>().refreshPosts();
                  await context.read<OfferViewModel>().refreshOffer();

                },
                // child: SingleChildScrollView(
                //   controller: _scrollController,
                //   physics: const AlwaysScrollableScrollPhysics(),
                //   child: Container(
                //     margin: const EdgeInsets.symmetric(horizontal: 10),
                //     child: Column(
                //       children: [
                //         Container(
                //           margin: const EdgeInsets.symmetric(vertical: 10),
                //           child: SizedBox(
                //             height: 200,
                //             width: double.infinity,
                //             child: HomeVideoBanner(),
                //           ),
                //         ),
                //
                //         const PostSection(),
                //         const SizedBox(height: 100),
                //       ],
                //     ),
                //   ),
                // ),
                 child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: bannerVM.topBanners.isNotEmpty
                        ? PageView.builder(
                      itemCount: bannerVM.topBanners.length,
                      itemBuilder: (context, index) {
                        final banner = bannerVM.topBanners[index];
                        final imageUrl = banner.mediaUrl ?? banner.bannerImageUrl ?? "";
                        if (imageUrl.isEmpty) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/homebanner2.jpeg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        }
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/homebanner2.jpeg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    )
                        // : HomeVideoBanner(),
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/homebanner2.jpeg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),

                // Consumer<ProfileViewModel>(
                //   builder: (context, profileVm, child) {
                //     final profile = profileVm.profileModel;
                //
                //     // shop illa enkil mathram kaanikku
                //     if (profile == null || profile.accountType == "shop") {
                //       return SizedBox();
                //     }
                //
                //     // return Padding(
                //     //   padding: const EdgeInsets.symmetric(vertical: 10),
                //     //   child: CustomElavatedTextButton(
                //     //     text: "Create Store",
                //     //     bgcolor: Color(0xFFFB8C00),
                //     //     borderRadius: 12,
                //     //     onPressed: () {
                //     //       context.pushNamed(PPages.subscriptionScreen);
                //     //     },
                //     //   ),
                //     // );
                //   },
                // ),

                 OfferSection(id: "some_id"),
                   // OfferSection(),
                 // const PostSection(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
              ),

              // Assistant hint bubble
              if (_assistantHintVisible)
                Positioned(
                  bottom: 140,
                  right: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          // 'For technical assistance, chat with us',
                          // "Join our updates group ",
                               "stay connected with every opportunity",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      // Triangle pointer
                      Transform.translate(
                        offset: const Offset(8, -1),
                        child: Transform.rotate(
                          angle: 3.14 / 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                          AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
                child: Consumer<PostViewModel>(
                  builder: (context, value, child) => value.isBottomshetopen
                      ? const SizedBox()
                      : Stack(
                          children: [
                            // Main FAB for creating posts
                            // Positioned(
                            //   bottom: 10,
                            //   right: 0,
                            //   // child: FloatingActionButton(
                            //   //   shape: const CircleBorder(),
                            //   //   heroTag: 'createPost',
                            //   //   backgroundColor:Color(0xFF8A4FFF),
                            //   //   onPressed: () {
                            //   //     final profile = context.read<ProfileViewModel>().profileModel;
                            //   //     final accountType = profile?.accountType?.toLowerCase().trim() ?? 'normal';
                            //   //     if (accountType == 'freelancer' || accountType == 'premium') {
                            //   //                                       showModalBottomSheet(
                            //   //       context: context,
                            //   //       isScrollControlled: true,
                            //   //       builder: (context) => const HomeFloatingActionButtonUi(),
                            //   //     );
                            //   //     } else {
                            //   //       context.pushNamed(PPages.planListUi);
                            //   //     }
                            //   //   },
                            //   //   child: const Icon(Icons.add, color: Colors.white),
                            //   // ),
                            // ),
                            // Assistant WhatsApp FAB
                            // Positioned(
                            //   bottom: 80,
                            //   right: 0,
                            //   child: FloatingActionButton(
                            //     shape: const CircleBorder(),
                            //     heroTag: 'whatsappAssistant',
                            //     backgroundColor: const Color(0xFF8A4FFF),
                            //     // onPressed: () => _openWhatsApp('+919847561998'),
                            //     onPressed: () => _openWhatsApp('https://chat.whatsapp.com/CziCbs0nTjYHXU9kMXhMrW?mode=gi_t'),
                            //     child: const Icon(Icons.chat, color: Colors.white),
                            //   ),
                            // ),
                            Positioned(
                              bottom: 30,
                              right: 0,
                              child: FloatingActionButton(
                                shape: const CircleBorder(),
                                heroTag: 'whatsappAssistant',
                                backgroundColor:  primaryColor,
                                onPressed: openWhatsAppGroup,
                                child: const Icon(Icons.chat, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerWidget(
      {required String title, required Widget icon, required Function()? fun}) {
    return ListTile(
        leading: icon,
        title: textWidget(
            text: title,
            color: title == "Logout" ? PColors.red :  primaryColor),
        onTap: fun);
  }

  logoutBox(
      {required BuildContext context,
      required String title,
      required Function()? onTap}) {
    return AlertDialog(
      backgroundColor: PColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close))
            ],
          ),
          textWidget(
              textAlign: TextAlign.center,
              text: title,
              fontweight: FontWeight.w600,
              color: PColors.black,
              fontsize: 19),
          const SizedBox(
            height: 20,
          ),
          CustomElavatedTextButton(
              text: "Yes",
              borderRadius: 24,
              bgcolor: primaryColor,
              onPressed: onTap),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: textWidget(
                  text: "Cancel",
                  fontweight: FontWeight.w600,
                  color: primaryColor,
                  fontsize: 16)),
        ],
      ),
    );
  }
}

Future<void> _openWhatsApp(String phoneNumber) async {
  // Attempt to open WhatsApp directly; if not installed, fallback to web.
  Uri uri = Uri.parse('whatsapp://send?phone=$phoneNumber');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return;
  }
  uri = Uri.parse('https://wa.me/${phoneNumber.replaceAll('+', '')}');
  if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;

  EasyLoading.showError('Could not open WhatsApp');
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
