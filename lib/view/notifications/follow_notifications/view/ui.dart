import 'package:flutter/material.dart';
import 'package:biz_zinda/view/notifications/follow_notifications/view/widgets/follow_single_notification.dart';

class FollowNotificationWidget extends StatelessWidget {
  const FollowNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) => const FollowSingleNotificationUi(),
      ),
    );
  }
}
