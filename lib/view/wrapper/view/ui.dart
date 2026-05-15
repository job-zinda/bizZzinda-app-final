import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/view/wrapper/view/widgets/bottom_nv_bar.dart';

class WrapperView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const WrapperView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(navigationShell: navigationShell),
    );
  }
}
