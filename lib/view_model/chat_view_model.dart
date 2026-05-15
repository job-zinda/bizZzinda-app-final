import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../model/conversation_model.dart';
import '../utils/api_service.dart';
import '../utils/api_url.dart';

class ChatViewStatus {
  static const String primary = "Primary";
  static const String letsPlan = "Lets plan";

  static const String all = "All";
  static const String unread = "Unread";
}

class ChatViewModel extends ChangeNotifier {
  String view = ChatViewStatus.primary;
  String allUnreadView = ChatViewStatus.all;

  updateView(String val) {
    view = val;
    notifyListeners();
  }

  updateAllAndUnread(String val) {
    allUnreadView = val;
    notifyListeners();
  }

  List<ConversationModel> conversationList = [];
  Future<void> fetchAllConversations() async {
    EasyLoading.show();
    Response response = await ApiService().get(Api.conversationListUrl);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print("converstaion -----$data");

      if (data['status']) {
        conversationList = (data['data']['conversations'] as List)
            .map(
              (e) => ConversationModel.fromJson(e),
            )
            .toList();

        // Debugging: Print the number of conversations fetched
        print("Total conversations fetched: ${conversationList.length}");
      } else {
        conversationList.clear();
      }
      notifyListeners();
    }
    EasyLoading.dismiss();
  }
}
