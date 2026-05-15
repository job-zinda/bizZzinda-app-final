import 'package:flutter/material.dart';
import 'package:biz_zinda/view/subscription_page/view/widgets/subscription_heading.dart';
import 'package:biz_zinda/view/subscription_page/view/widgets/subscription_body.dart';

class ProfileViewBodyUi extends StatelessWidget {
  const ProfileViewBodyUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      child: const Column(
        children: [
          SizedBox(
            height: 20,
          ),
          SubscriptionHeading(),
          SubscriptionBodyUi()
        ],
      ),
    );
  }
}
