import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/notification_model.dart';
import 'package:biz_zinda/view_model/notification_view_model.dart';
import 'package:provider/provider.dart';

class DeleteBottomSheet extends StatelessWidget {
  final NotificationModel? notificationModel;
  const DeleteBottomSheet({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PColors.black2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            itemWidget(
                icon: PSvgs.delete,
                title: 'Delete',
                fun: () {
                  context
                      .read<NotificationViewModel>()
                      .deleteNotification(notificationModel?.sId ?? '');
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  Widget itemWidget(
      {required String icon, required String title, required Function()? fun}) {
    return ListTile(
      onTap: fun,
      leading: SvgPicture.asset(
        icon,
        height: 24,
      ),
      title: textWidget(text: title, color: PColors.red, fontsize: 15),
    );
  }
}
