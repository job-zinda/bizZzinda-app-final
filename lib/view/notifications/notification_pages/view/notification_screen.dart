import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/noification_tab_section.dart';
import 'package:biz_zinda/view/notifications/notification_pages/view/widgets/notification_body_section.dart';
import 'package:biz_zinda/view_model/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vm = context.read<NotificationViewModel>();

      vm.currentPage = 0;

      vm.notificatonController.refresh();
      vm.initNotificationPagination();

      vm.fetchNotificationCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWidget(text: 'Notification'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 17),
        child: const Column(
          children: [
            NotificationTabSection(),
            SizedBox(height: 30),
            NotificationBodySection(),
          ],
        ),
      ),
    );
  }
}