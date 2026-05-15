
import 'package:biz_zinda/Data/Network/network_controller.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off),
              const Text("Check your Internet connectivity!!!"),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    NetConnection.networkConnection(context)
                        .then((value) async {
                      if (value == true) {
                        context.go('/home');
                      }
                    });
                  },
                  child: const Icon(Icons.refresh))
            ],
          ),
        ),
      ),
    );
  }
}
