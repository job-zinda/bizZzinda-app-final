import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:biz_zinda/model/referal_model.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';

class ReferalViewModel extends ChangeNotifier {
  bool isPaginationloading = false;

  bool loading = false;
  int? pageNumber = 1;
  bool hasMore = true;

  List<Referrals> referlaList = [];
  
  Future<void> fetchReferlaList(BuildContext context) async {
    loading = true;
    notifyListeners();
    pageNumber = 1;
    referlaList.clear();
    String api = "${Api.fetchReferals}?pageNumber=$pageNumber&pageSize=10";

    Response response = await ApiService().get(api);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print(response.data.toString());

      if (data['status']) {
        if (data['data']['referrals'] != null) {
          referlaList = (data['data']['referrals'] as List)
              .map((e) => Referrals.fromJson(e))
              .toList();
        }
        print("refrla list---$referlaList");
      }
    }
loading=false;
    notifyListeners();
  }

  fetchPaginatedRefrelas() async {
    if (isPaginationloading) return;
    isPaginationloading = true;
    notifyListeners();
    pageNumber = pageNumber! + 1;

    String api = "${Api.fetchReferals}?pageNumber=$pageNumber&pageSize=10";

    Response response = await ApiService().get(api);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      print(response.data.toString());

      if (data['status']) {
        if (data['data']['referrals'] != null) {
          referlaList = (data['data']['referrals'] as List)
              .map((e) => Referrals.fromJson(e))
              .toList();
        }
      }

      if (referlaList.isNotEmpty) {
        hasMore = true;
        notifyListeners();
      } else {
        hasMore = false;
        notifyListeners();
      }

      if (referlaList.isNotEmpty) {
        for (var item in referlaList) {
          referlaList.add(item);
        }
      }
    }

    isPaginationloading = false;
    notifyListeners();
  }
}
