import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingShow {
  static load(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: Center(
                child: SpinKitFadingGrid(
                  color: PColors.seed,
                  size: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static stopLoad(BuildContext context) {
    Navigator.pop(context);
  }

  static doLoad(BuildContext context, bool isLoad) {
    if (isLoad == true) {
      load(context);
    } else {
      stopLoad(context);
    }
  }
}
