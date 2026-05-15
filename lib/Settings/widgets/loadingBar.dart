
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../until/PColors.dart';

class LoadingBar {
  static Widget buttonLoad() =>
      SpinKitWaveSpinner(color: PColors.white, size: 40);

  static Widget loading() {
    return SpinKitFadingCircle(
      color: PColors.seed,
      size: 50.0,
    );
  }

  static popUpLoadingBar(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCube(
                size: 20,
                color: Colors.white,
              ),
              SizedBox(width: 40),
              //sconst Text("Loading...")
            ],
          ),
        );
      },
    );
  }

  static offPopLoadingBar(BuildContext context) {
    Navigator.pop(context);
  }
}
