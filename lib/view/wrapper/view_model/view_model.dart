import 'package:flutter/material.dart';

class WrapperViewStatus {
  static const String home = "Home";
  static const String search = "Search";
  static const String profile = "Profile";
  static const String normalProfile = "Normal profile";

  static const String upload = "Upload";
  static const String connect = "Connection";
  static const String otherProfile = "Other Profile";
  static const String profile_view = "Profile view";
  static const String freelancer_createAccount = "Create Account";






}

class WrapperViewModel extends ChangeNotifier {
  String viewStatus = WrapperViewStatus.home;
  String? userId;

  updatePageView(String value, {String? id}) {
    viewStatus = value;
    userId = id;
    notifyListeners();
  }
}
