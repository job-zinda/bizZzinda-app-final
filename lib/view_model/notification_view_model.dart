import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/model/notification_model.dart';
import 'package:biz_zinda/utils/api_url.dart';

import '../utils/api_service.dart';

class NotificationViewStatus {
  static const String allNotification = 'All';
  static const String commentsNotification = 'Comments';
  static const String profileViewsNotification = 'Profile views';
  static const String followNotification = 'Follow';
}

class NotificationViewModel extends ChangeNotifier {
  String view = NotificationViewStatus.allNotification;
  updateViewStatus(String val) {
    view = val;
    notifyListeners();
  }

  late PagingController<int, NotificationModel> notificatonController;
  int currentPage = 0;
  initNotificationPagination() {
    currentPage = 0;
    notificatonController = PagingController(firstPageKey: 1);
    notificatonController.addPageRequestListener((pageKey) {
      fetchNotificationWithPagination(pageKey);
    });
  }

  Future<void> fetchNotificationWithPagination(int page) async {
    if (currentPage != page) {
      currentPage = page;
      String action = view == NotificationViewStatus.allNotification
          ? ''
          : view == NotificationViewStatus.followNotification
              ? 'follow'
              : view == NotificationViewStatus.profileViewsNotification
                  ? 'profile_view'
                  : 'comment';
      String api = Api.fetchNotificationsUrl;
      Response response = await ApiService()
          .get('$api&pageNumber=$page&notificationType=$action');
      log(response.data.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          List<NotificationModel> temp = (data['data']['notifications'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList();
          if (data['data']['hasNext']) {
            notificatonController.appendPage(temp, page + 1);
          } else {
            notificatonController.appendLastPage(temp);
          }
        } else {
          notificatonController.appendLastPage([]);
        }
      } else {
        notificatonController.appendLastPage([]);
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    EasyLoading.show();
    Response response = await ApiService().delete('${Api.deleteComment}/$id');
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        EasyLoading.showSuccess(data['message']);
        currentPage = 0;
        notificatonController.refresh();
      }
    }
    EasyLoading.dismiss();
  }

  int notificationCount = 0;
  Future<void> fetchNotificationCount() async {
    Response response = await ApiService().get(Api.fetchNotificationCount);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        notificationCount = data['data']['totalCount'];
        notifyListeners();
      }
    }
  }

  Future<void> notificationRead({required String id}) async {
    await ApiService().patch('${Api.notificationRead}/$id');
    fetchNotificationCount();
  }

}
