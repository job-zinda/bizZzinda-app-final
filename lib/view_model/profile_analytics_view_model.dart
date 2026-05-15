import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';

import '../model/analytics_model.dart';

class ProfileAnalyticsViewModel with ChangeNotifier {
  AnalyticsModel? analyticsModel;
  Future<void> fetchProfileAnalytics({required String filter}) async {
    EasyLoading.show();
    Response response = await ApiService()
        .get('${Api.fetchProfileAnalyticsUrl}?dateFilter=$filter');
    log(response.data.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data['status']) {
        analyticsModel = AnalyticsModel.fromJson(data['data']['analytics']);
        notifyListeners();
      }
    }
    EasyLoading.dismiss();
  }
}
