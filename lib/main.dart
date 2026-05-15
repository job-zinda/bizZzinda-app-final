import 'package:biz_zinda/view/Create_My_Offer/OfferSectionWidget.dart';
import 'package:biz_zinda/view/Shop/create_shope_page.dart';
import 'package:biz_zinda/view/shop/shop_dashboard_page.dart' show ShopDashboardScreen;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PRoutes.dart';
import 'package:biz_zinda/Settings/until/PText_styles.dart';
import 'package:biz_zinda/firebase_options.dart';
import 'package:biz_zinda/notification_service.dart';
import 'package:biz_zinda/services/app_link_service.dart';
import 'package:biz_zinda/services/app_link_service.dart';
import 'package:biz_zinda/utils/providers.dart';
import 'package:biz_zinda/view/login_section/login_welcome_screen/view/enterEmailUi.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/my_profile_button.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/noification_tab_section.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/notification_body_section.dart';
import 'package:biz_zinda/view/profile_view/view/ui.dart';
import 'package:biz_zinda/view/upload_pages/view/ui.dart';
import 'package:biz_zinda/view_model/chat_badge_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
// TODO: Verify and update this import path if necessary
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
import 'package:biz_zinda/view/splash/view/splash_screen.dart';
import 'package:biz_zinda/view/wrapper/view/ui.dart';
import 'package:biz_zinda/view/welcome/view/ui.dart'; // For WelcomePageUi
import 'package:biz_zinda/view/login_section/add_newuser/view/ui.dart'; // For AddUserPage

// --- Additions by Cascade to fix build errors ---
import 'package:biz_zinda/view/home_section/home_pages/view/home_screen.dart';
import 'package:biz_zinda/view/search_section/view/search_screen.dart';
import 'package:biz_zinda/view/connect_pages/map_section/view/ui.dart';
import 'package:biz_zinda/view/my_profile/view/profile_screen.dart';
import 'package:biz_zinda/view/plan_ui/ui.dart';
import 'package:biz_zinda/view/my_profile/view/course_purchase/course_purchase_ui.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
// --- End Additions by Cascade ---

// Additional imports based on PRoutes.dart
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/no_internet.dart';
import 'package:biz_zinda/view/chat_details_page/view/ui.dart'; // ChatDetailsPageui
import 'package:biz_zinda/view/chat_section/chat_pages/view/ui.dart'; // ChatPageUi
import 'package:biz_zinda/view/coin_page/coin_screen.dart'; // CoinScreenUi
import 'package:biz_zinda/view/task_corner_assignments.dart';
import 'package:biz_zinda/view/connect_pages/filter_freelancers/view/ui.dart'; // FreelancerFilterPageUi
import 'package:biz_zinda/view/edit_profile/view/edit_profile_screen.dart'; // EditProfileScreen
import 'package:biz_zinda/view/followers_list/view/ui.dart'; // FollowersScreen
import 'package:biz_zinda/view/followers_list/view/widgets/feedback_list.dart'; // FeedbackListScreen
import 'package:biz_zinda/view/freelancer_edit_profile/ui.dart'; // FreeLancerEditProfileUi
import 'package:biz_zinda/view/freelancer_edit_profile/widgets/bio_page.dart'; // FreelancerBioPageUi
import 'package:biz_zinda/view/freelancer_edit_profile/widgets/search_location.dart'; // SearchLocation
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/add_story_screen.dart'; // AddStoryScreen
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/storyView_page.dart'; // StoryViewer
import 'package:biz_zinda/view/login_section/referal_code/view/ui.dart'; // ReferalCodeUi
import 'package:biz_zinda/view/my_profile/view/widgets/profile_post_details.dart'; // ProfilePostDetailsUi
import 'package:biz_zinda/view/profile_analytics/view/profile_analytics_screen.dart'; // ProfileAnalyticsScreen
import 'package:biz_zinda/view/help_support/view/ui.dart'; // HelpSupportUi
import 'package:biz_zinda/view/help_support/view/widgets/send_feedback_ui.dart'; // SendFeedbackUi
import 'package:biz_zinda/view/login_section/login_splash/view/ui.dart'; // LoginSplashUi
import 'package:biz_zinda/view/login_section/login_splash/view/widgets/login_splash_2.dart'; // LoginSplash2Ui
import 'package:biz_zinda/view/login_section/login_welcome_screen/view/ui.dart'; // LoginWelcomeScreenUi
import 'package:biz_zinda/view/login_section/username_login/view/ui.dart'; // UsernameLoginScreen
import 'package:biz_zinda/view/login_section/username_login/view/change_password_ui.dart'; // ChangePasswordScreen
import 'package:biz_zinda/view/login_section/otp_verify/view/ui.dart'; // OtpPageUi
import 'package:biz_zinda/view/login_section/phone_number_ui/view/login_screen.dart'; // LoginScreen
import 'package:biz_zinda/view/notifications/notification_pages/view/notification_screen.dart'; // NotificationScreen
import 'package:biz_zinda/view/my_profile/view/wallet_screen.dart';
import 'package:biz_zinda/view/referal_page/referal_page_ui.dart'; // ReferalPageUi
import 'package:biz_zinda/view/subscription_page/view/ui.dart'; // For SubscriptionPageUi
import 'package:biz_zinda/view/plan_ui/widgets/plan_list.dart'; // For PlanListUi
import 'package:biz_zinda/view/upload_pages/view/widgets/add_post_screen.dart'; // AddPostScreen
import 'package:biz_zinda/view/welcome/view/widgets/onboarding_screen_ui.dart'; // OnboardingScreensUi
// OtherUserProfileScreen, SplashScreen, WrapperView are already imported.

import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart'; // For LoginPhoneNumberViewModel
import 'package:firebase_messaging/firebase_messaging.dart';

import 'store_subscription/subscription_screen.dart';




// Must be a top-level function (e.g. not a class method)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //Initialise the notification service
  await FCMService().initialize();
  debugPrint("Handling a background message: ${message.messageId}");
}

bool _isInitialized = false;

Future<void> main() async {
  // Wrap entire app initialization in the same zone to avoid zone-mismatch errors.
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('HB-INIT | Firebase initialized');

    // Set up background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize other services
    await FCMService().initialize();
    debugPrint('HB-INIT | FCM service initialized');
    unawaited(AppLinkService().init());
    debugPrint('HB-INIT | AppLinkService initialized');

    // Configure loading indicator
    configLoading();
    debugPrint('HB-INIT | configLoading complete');

    // Limit Flutter image cache to avoid excessive RAM
    PaintingBinding.instance.imageCache
      ..maximumSize = 100
      ..maximumSizeBytes = 50 * 1024 * 1024;

  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  // Configure global error handlers for Crashlytics
  FlutterError.onError = (FlutterErrorDetails details) {
    final exceptionStr = details.exception.toString();
    // Downgrade common NetworkImage URI mistakes to non-fatal so the app doesn’t crash.
    if (exceptionStr.contains('No host specified') ||
        exceptionStr.contains('Connection closed') ||
        exceptionStr.contains('Handshake error') ||
        exceptionStr.contains('tile.openstreetmap.org') ||
        exceptionStr.contains('ClientException')) {
      FirebaseCrashlytics.instance
          .recordError(details.exception, details.stack, fatal: false);
      return;
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

   // All initialization complete – launch the UI
    runApp(
      MultiProvider(

        providers: providers,
        child: const MyApp(),

      ),
    );


  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
final _shellNavigatorConnectKey = GlobalKey<NavigatorState>(debugLabel: 'shellConnect');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

// Define the GoRouter instance
// This router will handle deep links for profiles and can be expanded for other routes.

final GoRouter mainAppRouter = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: navigatorKey, // Share the navigatorKey
  initialLocation: PPages.splash, // Set initial location
  redirect: (BuildContext context, GoRouterState state) {
    // Use the AppLinkService to check if the app has finished initializing.
    final appLinkService = AppLinkService();
    if (!appLinkService.isInitializationComplete) {
      // While the app is initializing, allow navigation only to the splash screen.
      // Redirect all other attempts to the splash screen.
      final isGoingToSplash = state.matchedLocation == PPages.splash;
      return isGoingToSplash ? null : PPages.splash;
    }

    // If the app is initialized and the user is at the root, redirect to the home screen.
    if (state.matchedLocation == '/') {
      return '/home';
    }

    // Once initialized, no redirection is needed.
    return null;
  },
  routes: <RouteBase>[
    // Define the profile route that GoRouter will handle
    GoRoute(
      path: PPages.splash,
      name: PPages.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: PPages.wallet,
      name: 'wallet',
      builder: (context, state) => const WalletScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return WrapperView(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/search',
              name: 'search',
              builder: (context, state) => SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorConnectKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/connect',
              name: 'connect',
              builder: (context, state) => ConnectPagesUi(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: <RouteBase>[
            GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) {
                  final profileVM = context.watch<ProfileViewModel>();
                  final profileType =
                      profileVM.profileModel?.accountType?.toLowerCase();
                  if (profileType == "normal") {
                    return PlanUi();
                  } else {
                    return ProfileScreen();
                  }
                },
                // builder: (context, state) {
                //   final profileVM = context.watch<ProfileViewModel>();
                //   final profile = profileVM.profileModel;
                //
                //   /// ⏳ loading
                //   if (profile == null) {
                //     return const Scaffold(
                //       body: Center(child: CircularProgressIndicator()),
                //     );
                //   }
                //
                //   final profileType = profile.accountType?.toLowerCase();
                //
                //   /// 🏪 SHOP OWNER → DASHBOARD
                //   if (profile.isShopOwner == true) {
                //     return const ShopDashboardScreen();
                //   }
                //
                //   /// 👤 NORMAL USER → PLAN UI
                //   if (profileType == "normal") {
                //     return PlanUi();
                //   }
                //
                //   /// ⭐ OTHER USERS → PROFILE
                //   return ProfileScreen();
                // },
                routes: [
                  GoRoute(
                    path: ':userId',
                    name: 'other-user-profile',
                    builder: (context, state) {
                      final userId = state.pathParameters['userId']!;
                      return OtherUserProfileScreen(userId: userId);
                    },
                  ),
                ]),
          ],
        ),
      ],
    ),
    GoRoute(
      name: PPages.subscriptionScreen,
      path: '/subscription',
      builder: (context, state) => SubscriptionScreen(),
    ),
    GoRoute(
      path: PPages.welcomePageUi,
      name: PPages.welcomePageUi,
      builder: (context, state) => WelcomePageUi(),
    ),
    GoRoute(
      path: PPages.onboardingScreensUi,
      name: PPages.onboardingScreensUi,
      builder: (context, state) => const OnboardingScreensUi(),
    ),
    // Make username/password the default landing login screen
    // GoRoute(
    //   path: PPages.loginWelcomeScreenUi,
    //   name: PPages.loginWelcomeScreenUi,
    //   builder: (context, state) => const UsernameLoginScreen(),
    // ),
    GoRoute(
      path: PPages.loginWelcomeScreenUi,
      name: PPages.loginWelcomeScreenUi,
      builder: (context, state) => const LoginWelcomeScreenUi(), // ✅ change here
    ),
    // GoRoute(
    //   path: '/enter-email',               // or whatever path you want
    //   name: PPages.enterEmailUi,          // <-- This is required for pushNamed
    //   builder: (context, state) {
    //     final data = state.extra as Map<String, dynamic>? ?? {};
    //     return EnterEmailScreen(data: data);
    //   },
    // ),
    GoRoute(
      path: PPages.usernameLoginUi,
      name: PPages.usernameLoginUi,
      builder: (context, state) => const UsernameLoginScreen(),
    ),
    GoRoute(
      path: PPages.changePasswordUi,
      name: PPages.changePasswordUi,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: PPages.phoneNumberUi,
      name: PPages.phoneNumberUi,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: PPages.otpPageUi,
      name: PPages.otpPageUi,
      builder: (context, state) {
        final model = state.extra as LoginPhoneNumberViewModel;
        return OtpPageUi(model: model);
      },
    ),
    GoRoute(
      path: PPages.loginSplashUi,
      name: PPages.loginSplashUi,
      builder: (context, state) => const LoginSplashUi(),
    ),
    GoRoute(
      path: PPages.storyViewer,
      name: PPages.storyViewer,
      builder: (context, state) =>
          StoryViewer(args: state.extra as StoryViewerArgs),
    ),
    GoRoute(
      path: PPages.loginSplash2Ui,
      name: PPages.loginSplash2Ui,
      builder: (context, state) => const LoginSplash2Ui(),
    ),
    GoRoute(
      path: PPages.helpSupportUi,
      name: PPages.helpSupportUi,
      builder: (context, state) => const HelpSupportUi(),
    ),
    GoRoute(
      path: PPages.sendFeedbackUi,
      name: PPages.sendFeedbackUi,
      builder: (context, state) => const SendFeedbackUi(),
    ),
    GoRoute(
      path: PPages.profilePostDetailsUi,
      name: PPages.profilePostDetailsUi,
      builder: (context, state) => const ProfilePostDetailsUi(),
    ),
    GoRoute(
      path: PPages.freeLancerEditProfileUi,
      name: PPages.freeLancerEditProfileUi,
      builder: (context, state) => const FreeLancerEditProfileUi(),
    ),
    GoRoute(
      path: PPages.notificationsUi,
      name: PPages.notificationsUi,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: PPages.chatPageUi,
      name: PPages.chatPageUi,
      builder: (context, state) => const ChatPageUi(),
    ),
    GoRoute(
      path: PPages.addPostUi,
      name: PPages.addPostUi,
      builder: (context, state) => const AddPostScreen(),
    ),
    GoRoute(
      path: PPages.addStoryScreenUi,
      name: PPages.addStoryScreenUi,
      builder: (context, state) => const AddStoryScreen(),
    ),
    GoRoute(
      path: PPages.chatDetailsPageui,
      name: PPages.chatDetailsPageui,
      builder: (context, state) => const ChatDetailsPageui(),
    ),
    GoRoute(
      name: PPages.profileScreen,
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: PPages.editProfileUi,
      name: PPages.editProfileUi,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: PPages.freelancerFilterPageUi,
      name: PPages.freelancerFilterPageUi,
      builder: (context, state) => const FreelancerFilterPageUi(),
    ),
    GoRoute(
      path: PPages.profileAnalyticsPageUi,
      name: PPages.profileAnalyticsPageUi,
      builder: (context, state) => const ProfileAnalyticsScreen(),
    ),
    GoRoute(
      path: PPages.subscriptionPageUi,
      name: PPages.subscriptionPageUi,
      builder: (context, state) => const PlanUi(),
    ),
    GoRoute(
      path: PPages.coursePurchaseUi,
      name: PPages.coursePurchaseUi,
      builder: (context, state) => const CoursePurchaseUi(),
    ),
    GoRoute(
      path: PPages.planListUi,
      name: PPages.planListUi,
      builder: (context, state) => const PlanListUi(),
    ),
    GoRoute(
      path: PPages.freelancerBioPageUi,
      name: PPages.freelancerBioPageUi,
      builder: (context, state) => const FreelancerBioPageUi(),
    ),
    GoRoute(
      path: '/createShop',
      name: '/createShop',
      builder: (context, state) => const CreateShopPage(),
    ),
    GoRoute(
      path: '/offering/:id',
      name: 'offering',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OfferSection(id: id);
      },
    ),

    GoRoute(
      path: PPages.searchLocation,
      name: PPages.searchLocation,
      builder: (context, state) {
        final page = state.extra as String?;
        return SearchLocation(page: page ?? '');
      },
    ),
    GoRoute(
      path: PPages.noIntenet,
      name: PPages.noIntenet,
      builder: (context, state) => const NoInternetWidget(),
    ),
    // GoRoute(
    //   path: PPages.adduserpage,
    //   name: PPages.adduserpage,
    //   builder: (context, state) => const AddUserPage(),
    // ),
    GoRoute(
      path: PPages.referalCodeUi,
      name: PPages.referalCodeUi,
      builder: (context, state) => const ReferalCodeUi(),
    ),
    GoRoute(
      path: PPages.referalPageUi,
      name: PPages.referalPageUi,
      builder: (context, state) => const ReferalPageUi(),
    ),
    GoRoute(
      path: PPages.taskCornerAssignments,
      name: PPages.taskCornerAssignments,
      builder: (context, state) => const TaskCornerAssignmentsPage(),
    ),
    GoRoute(
      path: PPages.coinScreenUi,
      name: PPages.coinScreenUi,
      builder: (context, state) => const CoinScreenUi(),
    ),
    GoRoute(
      path: '${PPages.followersScreen}/:profileId',
      name: PPages.followersScreen,
      builder: (context, state) {
        final profileId = state.pathParameters['profileId']!;
        return FollowersScreen(profileId: profileId);
      },
    ),
    GoRoute(
      path: '${PPages.feedbackScreen}/:profileId', // ✅ ADD THIS
      name: PPages.feedbackScreen,
      builder: (context, state) {
        final profileId = state.pathParameters['profileId']!;
        return FeedbackListUI(profileId: profileId);
      },
    ),
    GoRoute(
      path: PPages.storyDisplayPageUi,
      name: PPages.storyDisplayPageUi,
      builder: (context, state) {
        // TODO: Replace with actual DisplayStoryPage widget and arguments if needed
        // For now, using a placeholder if DisplayStoryPage is not ready
        // return DisplayStoryPage();
        return const Center(child: Text("Story Display Page - Placeholder"));
      },
    ),
  ],
  onException: (context, state, router) {
    debugPrint("### GoRouter.onException Triggered ### URI: ${state.uri}, Error: ${state.error}");

    // If the exception is from our custom deep link scheme, we ignore it.
    if (state.uri.toString().startsWith('com.jobzinda.customers://')) {
      debugPrint("  Ignoring exception for custom deep link scheme.");
      return;
    }

    // To prevent an infinite loop, don't redirect if we're already on the splash page.
    if (state.matchedLocation != PPages.splash) {
      debugPrint("  Redirecting to splash screen as a fallback.");
      router.go(PPages.splash);
    } else {
      debugPrint("  Exception occurred on splash screen. Halting redirection to prevent loop.");
    }
  },
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    // Ensure context is available and used safely, typically after the first frame or checking `mounted`
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BadgeViewModel>().fetchNotificationCount();
        context.read<BadgeViewModel>().fetchAdminMessageCount();
        context.read<BadgeViewModel>().fetchUserMessageMessageCount();
        debugPrint("APP SERVICES INITIALIZED IN main() or via provider");
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // AppLinkService is a singleton and will live for the duration of the app.
    // If it needs cleanup, it should be handled carefully, e.g., in a top-level binding.
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) { // Check if the widget is still in the tree
        context.read<BadgeViewModel>().fetchNotificationCount();
        context.read<BadgeViewModel>().fetchAdminMessageCount();
        context.read<BadgeViewModel>().fetchUserMessageMessageCount();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: mainAppRouter.routeInformationProvider,
      routeInformationParser: mainAppRouter.routeInformationParser,
      routerDelegate: mainAppRouter.routerDelegate,
      title: 'Biz Zinda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        highlightColor: Colors.transparent, // Kept from original simple version
        splashColor: Colors.transparent,   // Kept from original simple version
        textTheme: const TextTheme(
          bodySmall: TextStyle(),
          bodyMedium: TextStyle(),
          bodyLarge: TextStyle(),
        ).apply( // Applying to the TextTheme
          bodyColor: Colors.orange.shade200,
          displayColor: PColors.white,
        ),
        scaffoldBackgroundColor: PColors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: PColors.seed),
        iconTheme: IconThemeData(color: Color(0xFFFB8C00)),
        useMaterial3: true,

        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFB8C00),
          surfaceTintColor: Color(0xFFFB8C00),
          foregroundColor: PColors.white,
          centerTitle: true,
          titleTextStyle: PTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),

      builder: EasyLoading.init(
        builder: (context, child) {
          // SnackBarMessages().init(context);
          return child!;
        },
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
