import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';

class BadgeViewModel extends ChangeNotifier {
  int notificationCount = 0;
  int adminMessageCount = 0;
  int userMessageCount = 0;

  Future<void> fetchNotificationCount() async {
    Response response = await ApiService().get(Api.fetchNotificationCount);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        notificationCount = data['data']['totalCount'];

        print("noti count----$notificationCount");
        notifyListeners();
      }
    }
  }

  notificationRead() async {
    await ApiService().patch('${Api.allNnotificationRead}');
    fetchNotificationCount();
  }

  String? _conversationId;
  String? _lastMessageId;

  String? get conversationId => _conversationId;
  String? get lastMessageId => _lastMessageId;

  void setConversationId(String id) {
    _conversationId = id;
    notifyListeners(); // Optional: Only if UI depends on this
  }

  void setLastMessageId(String id) {
    _lastMessageId = id;
    notifyListeners(); // Optional
  }

  Future<void> updatemessage({required BuildContext context}) async {
    EasyLoading.show();

    Response response = await ApiService().post(Api.updateChat, {
      "conversationId": conversationId,
      "lastMessageId": lastMessageId,
    });
    log(response.data.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        fetchAdminMessageCount();
        fetchUserMessageMessageCount();
      }
    }
    EasyLoading.dismiss();
  }

  Future<void> fetchAdminMessageCount() async {
    Response response = await ApiService().get(Api.letsplanUnreadCount);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        adminMessageCount = data['data']['totalUnreadCount'];

        print("admin count----$adminMessageCount");
        notifyListeners();
      }
    }
  }

  Future<void> fetchUserMessageMessageCount() async {
    try {
      Response response = await ApiService().get(Api.userMessageUnreadCount);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          userMessageCount = data['data']['totalUnreadCount'];
        }
      }
    } on DioException catch (e, st) {
      // Network-related exception (e.g., connection reset). Log for Crashlytics but prevent UI crash.
      debugPrint('Error fetching user message count: \\${e.message}');
      FirebaseCrashlytics.instance.recordError(e, st, reason: 'fetchUserMessageMessageCount failed');
    } catch (e, st) {
      debugPrint('Unexpected error fetching user message count: $e');
      FirebaseCrashlytics.instance.recordError(e, st);
    } finally {
      notifyListeners();
    }
  }
}
