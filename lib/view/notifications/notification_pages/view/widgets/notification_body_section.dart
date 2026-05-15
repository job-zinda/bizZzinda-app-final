import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/model/notification_model.dart';
import 'package:biz_zinda/view_model/notification_view_model.dart';
import 'package:provider/provider.dart';

import '../../../profile_view_notifications/view/widgets/profile_view_single_noti.dart';

class NotificationBodySection extends StatefulWidget {
  const NotificationBodySection({super.key});

  @override
  State<NotificationBodySection> createState() =>
      _NotificationBodySectionState();
}

class _NotificationBodySectionState extends State<NotificationBodySection> {

  @override
  void initState() {
    super.initState();

    final notificationViewModel = context.read<NotificationViewModel>();
    notificationViewModel.currentPage = 0;
    notificationViewModel.initNotificationPagination();
  }

  @override
  Widget build(BuildContext context) {

    NotificationViewModel notificationViewModel =
    context.watch<NotificationViewModel>();

    return Expanded(
      child: PagedListView<int, NotificationModel>(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        pagingController: notificationViewModel.notificatonController,

        builderDelegate: PagedChildBuilderDelegate<NotificationModel>(

          itemBuilder: (context, item, index) {

            /// DEBUG PRINT
            print("Notification Type : ${item.notificationType}");
            print("Task ID : ${item.connectedTaskId}");

            return ProfileViewSingleNotiWidget(
              notificationModel: item,
            );
          },

          firstPageProgressIndicatorBuilder: (context) =>
          const Center(child: CircularProgressIndicator()),

          newPageProgressIndicatorBuilder: (context) =>
          const Center(child: CircularProgressIndicator()),

          firstPageErrorIndicatorBuilder: (context) =>
          const Center(child: Text("Error loading notifications")),

          newPageErrorIndicatorBuilder: (context) =>
          const Center(child: Text("Error loading more notifications")),

          noItemsFoundIndicatorBuilder: (context) => const SizedBox(
            height: 500,
            child: Center(child: Text('No data found')),
          ),
        ),
      ),
    );
  }
}