import 'package:flutter/material.dart';

class WelcomeViewModel extends ChangeNotifier {
  int page = 0;
  updatePageiew(int val) {
    page = val;
    notifyListeners();
  }
}
