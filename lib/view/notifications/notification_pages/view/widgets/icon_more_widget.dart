import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/delete_bottom_sheet.dart';

import '../../../../../model/notification_model.dart';

class IconMoreWidget extends StatelessWidget {  final NotificationModel? notificationModel;
  const IconMoreWidget({super.key, this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showBottomSheet(
            shape: const BeveledRectangleBorder(),
            clipBehavior: Clip.hardEdge,
            backgroundColor: PColors.white,
            context: context,
            builder: (context) => DeleteBottomSheet(notificationModel: notificationModel),
          );
        },
        child: Icon(
          Icons.more_vert,
          color: PColors.black,
        ));
  }
}
