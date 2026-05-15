import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/notification_view_model.dart';
import 'package:provider/provider.dart';

class NotificationTabSection extends StatelessWidget {
  const NotificationTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationViewModel notificationViewModel =
        context.read<NotificationViewModel>();
    Size size = MediaQuery.of(context).size;
    return Selector<NotificationViewModel, String>(
      selector: (p0, p1) => p1.view,
      builder: (context, value, child) => Container(
        margin: const EdgeInsets.only(left: 13, right: 6),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          singleWidget(
              size: size,
              str: 'All',
              fun: () {
                notificationViewModel
                    .updateViewStatus(NotificationViewStatus.allNotification);
                notificationViewModel.currentPage = 0;
                notificationViewModel.notificatonController.refresh();
              },
              selected: value == NotificationViewStatus.allNotification),
          singleWidget(
              size: size,
              str: 'Follow',
              fun: () {
                notificationViewModel.updateViewStatus(
                    NotificationViewStatus.followNotification);
                notificationViewModel.currentPage = 0;
                notificationViewModel.notificatonController.refresh();
              },
              selected: value == NotificationViewStatus.followNotification),
          singleWidget(
              size: size,
              str: 'Profile Views',
              fun: () {
                notificationViewModel.updateViewStatus(
                    NotificationViewStatus.profileViewsNotification);
                notificationViewModel.currentPage = 0;
                notificationViewModel.notificatonController.refresh();
              },
              selected:
                  value == NotificationViewStatus.profileViewsNotification),
          singleWidget(
              size: size,
              str: 'Comments',
              fun: () {
                notificationViewModel.updateViewStatus(
                    NotificationViewStatus.commentsNotification);
                notificationViewModel.currentPage = 0;
                notificationViewModel.notificatonController.refresh();
              },
              selected: value == NotificationViewStatus.commentsNotification),
        ]),
      ),
    );
  }

  Widget singleWidget(
      {required Size size,
      required String str,
      required Function()? fun,
      required bool selected}) {
    return GestureDetector(
      onTap: fun,
      child: Container(
          // width: size.width / 4,
          child: Column(
        children: [
          textWidget(
              text: str,
              fontsize: 13,
              color:
                  selected ?  Color(0xFF8A4FFF) : Colors.grey,
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
          const SizedBox(
            height: 5
          ),
          Container(
            width: size.width / 4.6,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: selected
                      ? [PColors.grad1, PColors.grad2]
                      : [PColors.black, PColors.black],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            // margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
            // width: size.width / 4,
            height: 2,
          )
        ],
      )),
    );
  }
}
