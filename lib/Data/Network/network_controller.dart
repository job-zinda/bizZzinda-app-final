

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Settings/until/PColors.dart';


class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  // BuildContext context;
  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(
      updateConnectionStatus,
    );
  }

  void updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    for (var result in connectivityResult) {
      if (result == ConnectivityResult.none) {
        print('No internet connection');
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (BuildContext context) {
        //     return Internet();
        //   },
        // ));
        Get.rawSnackbar(
            messageText: Text(
              "Please connect to the internet".toUpperCase(),
              style: TextStyle(fontSize: 14, color: PColors.white),
            ),
            isDismissible: false,
            duration: const Duration(days: 1),
            backgroundColor: const Color.fromARGB(255, 222, 62, 51),
            icon: Icon(
              Icons.wifi_off,
              color: PColors.white,
              size: 35,
            ),
            margin: EdgeInsets.zero,
            snackStyle: SnackStyle.GROUNDED);
      } else {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
      }
    }
  }
}

class NetConnection {
  static Future<bool> networkConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    for (var result in connectivityResult) {
      if (result == ConnectivityResult.none) {
        // final snackBar = SnackBar(
        //   content: Text('No internet connection'),
        //   action: SnackBarAction(
        //     label: 'Undo',
        //     onPressed: () {
        //       // Some code to undo the change.
        //     },
        //   ),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      } else {
        return true;
      }
    }
    return false;

    //   if (connectivityResult == ConnectivityResult.mobile) {
    //     return true;
    //     // I am connected to a mobile network.
    //   } else if (connectivityResult == ConnectivityResult.wifi) {
    //     return true;
    //   } else if (connectivityResult == ConnectivityResult.none) {
    //     print("noneeeee");
    //     final snackBar = SnackBar(
    //       content: Text('No internet connection'),
    //       action: SnackBarAction(
    //         label: 'Undo',
    //         onPressed: () {
    //           // Some code to undo the change.
    //         },
    //       ),
    //     );
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     print("Select a date");
    //     return false;
    //   }
    //   return false;
  }
}
