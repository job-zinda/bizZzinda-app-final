import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/services/app_link_service.dart';

import '../../../Settings/until/PPages.dart';
import '../../../model/logged_in_user.dart';
import 'package:provider/provider.dart';
import '../../../view_model/location_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        checkLogin();
      }
    });
  }




  checkLogin() async {
    if (mounted) {
      await Provider.of<LocationViewModel>(context, listen: false)
          .checkLocation(context);
    }
    if (!mounted) return;

    await LoggedInUser.getUserDetails();
    if (!mounted) return;

    final appLinkService = AppLinkService();
    final String? deepLinkPath =
    await appLinkService.completeInitializationAndGetPath();
    if (!mounted) return;

    // -------------------------------
    // NEW: Show Email OTP page first if last login was via OTP
    // -------------------------------
    if (LoggedInUser.refreshToken == null) {
      // New user → show login options page
      context.replace(PPages.loginWelcomeScreenUi);
    } else if (LoggedInUser.lastLoginWasEmailOtp) {
      // Last login via Email OTP → force Email OTP screen first
      context.replace(PPages.enterEmailUi); // your email OTP page route
    } else if (LoggedInUser.accessToken != null && LoggedInUser.accessToken != '') {
      // Logged-in → go to Home / WrapperView
      context.replace('/', extra: deepLinkPath);
    } else {
      // Has refresh token but no access → Add user page
      context.replace(PPages.adduserpage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFB8C00),
      body: Center(
        child: Image.asset(
          PImages.logo4,scale: 5,
          fit: BoxFit.cover,
          // height: 150,
          // width: 150,
        ),
      ),
    );
  }
}
