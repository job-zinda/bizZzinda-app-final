import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/main.dart' as main_app;
import 'package:biz_zinda/Settings/until/PPages.dart';

import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';

class HelpViewModel extends ChangeNotifier {
  Future<void> sendFeedback(
      {required String rating, required String review}) async {
    if (rating.isEmpty) {
      EasyLoading.showError("Please select rating");
      return;
    }

    EasyLoading.show(status: 'Sending Feedback...');
    try {
      Map body = {'rating': rating, 'review': review};
      Response response = await ApiService().post(Api.sendFeedback, body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        print("feedback -----$data");

        if (data['status']) {
          EasyLoading.showSuccess("Feedback sent Successfully");
          if (main_app.navigatorKey.currentContext!.mounted) {
            main_app.navigatorKey.currentContext!.go('/home');
          }
        } else {
          EasyLoading.showError(data['message']);
        }
      } else {
        EasyLoading.showError(
            'Failed to send feedback. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending feedback: $e');
      EasyLoading.showError('An error occurred. Please try again.');
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }
}
