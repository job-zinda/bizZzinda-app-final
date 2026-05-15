

class Routes {
  /* static Route<dynamic>? genericRoute(RouteSettings settings) {
    switch (settings.name) {
      case PPages.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case PPages.welcomePageUi:
        return MaterialPageRoute(
          builder: (context) => WelcomePageUi(),
        );
      case PPages.onboardingScreensUi:
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreensUi(),
        );
      case PPages.loginWelcomeScreenUi:
        return MaterialPageRoute(
          builder: (context) => const LoginWelcomeScreenUi(),
        );
      case PPages.phoneNumberUi:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case PPages.otpPageUi:
        {
          dynamic model = settings.arguments!;
          return MaterialPageRoute(
            builder: (context) => OtpPageUi(
              model: model,
            ),
          );
        }

      case PPages.loginSplashUi:
        return MaterialPageRoute(
          builder: (context) => const LoginSplashUi(),
        );
      case PPages.storyViewer:
        return MaterialPageRoute(
          builder: (context) => StoryViewer(args: settings.arguments as StoryViewerArgs),
        );
      case PPages.loginSplash2Ui:
        return MaterialPageRoute(
          builder: (context) => const LoginSplash2Ui(),
        );

      case PPages.wrapperView:
        return MaterialPageRoute(
          builder: (context) => const WrapperView(),
        );
      case PPages.helpSupportUi:
        return MaterialPageRoute(
          builder: (context) => const HelpSupportUi(),
        );
      case PPages.sendFeedbackUi:
        return MaterialPageRoute(
          builder: (context) => const SendFeedbackUi(),
        );
      case PPages.profilePostDetailsUi:
        return MaterialPageRoute(
          builder: (context) => const ProfilePostDetailsUi(),
        );
      case PPages.freeLancerEditProfileUi:
        return MaterialPageRoute(
          builder: (context) => const FreeLancerEditProfileUi(),
        );

      case PPages.notificationsUi:
        return MaterialPageRoute(
          builder: (context) => const NotificationScreen(),
        );
      case PPages.chatPageUi:
        return MaterialPageRoute(
          builder: (context) => const ChatPageUi(),
        );
      case PPages.addPostUi:
        return MaterialPageRoute(
          builder: (context) => const AddPostScreen(),
        );
      case PPages.chatDetailsPageui:
        return MaterialPageRoute(
          builder: (context) => const ChatDetailsPageui(),
        );
      case PPages.editProfileUi:
        return MaterialPageRoute(
          builder: (context) => const EditProfileScreen(),
        );
      case PPages.profileView:
        final args = settings.arguments as Map<String, dynamic>?;
        final userId = args?['userId'] as String?;
        return MaterialPageRoute(
          builder: (context) => OtherUserProfileScreen(userId: userId),
        );
      case PPages.freelancerFilterPageUi:
        return MaterialPageRoute(
          builder: (context) => const FreelancerFilterPageUi(),
        );
      case PPages.profileAnalyticsPageUi:
        return MaterialPageRoute(
          builder: (context) => const ProfileAnalyticsScreen(),
        );
      case PPages.subscriptionPageUi:
        return MaterialPageRoute(
          builder: (context) => const SubscriptionPageUi(),
        );
      case AddStoryScreen.route:
        return MaterialPageRoute(
          builder: (context) => const AddStoryScreen(),
        );
      // case PostDetailsScreen.route:
      //   return MaterialPageRoute(
      //     builder: (context) => const PostDetailsScreen(),
      //   );
      // case PPages.storyDisplayPageUi:
      //   return MaterialPageRoute(
      //     builder: (context) => DisplayStoryPage(),
      //   );

      case PPages.freelancerBioPageUi:
        return MaterialPageRoute(
          builder: (context) => const FreelancerBioPageUi(),
        );
      case PPages.searchLocation:
        {
          var arg = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => SearchLocation(
              page: arg.toString(),
            ),
          );
        }

      case PPages.noIntenet:
        return MaterialPageRoute(
          builder: (context) => const NoInternetWidget(),
        );
      case PPages.adduserpage:
        return MaterialPageRoute(
          builder: (context) => const AddUserPage(),
        );
      case PPages.referalCodeUi:
        return MaterialPageRoute(
          builder: (context) => const ReferalCodeUi(),
        );

      case PPages.referalPageUi:
        return MaterialPageRoute(
          builder: (context) => const ReferalPageUi(),
        );
      case PPages.coinScreenUi:
        return MaterialPageRoute(
          builder: (context) => const CoinScreenUi(),
        );
      case PPages.followersScreen:
        {
          var id = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => FollowersScreen(
              profileId: id as String,
            ),
          );
        }
      case PPages.feedbackScreen:
        {
          var id = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => FeedbackListUI(
              profileId: id as String,
            ),
          );
        }

      default:
        return null;
    }
  }*/
}
