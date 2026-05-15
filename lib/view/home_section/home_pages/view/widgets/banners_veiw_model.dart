import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../../model/banners_model.dart';

class BannerViewModel extends ChangeNotifier {

  List<Banners> topBanners = [];
  Banners? middleBanner;
  Banners? bottomBanner;

  bool isLoading = false;

  Future<void> getBanners() async {

    try {

      isLoading = true;
      notifyListeners();

      Dio dio = Dio();

      final response = await dio.get(
        'http://10.0.2.2:4001/api/v1/banner/listBannersUser',
      );

      final bannerList = response.data['data']['banners'] as List;

      List<Banners> allBanners =
      bannerList.map((e) => Banners.fromJson(e)).toList();

      topBanners = allBanners
          .where((b) => b.position?.toLowerCase() == "top")
          .toList();

      final middleList = allBanners
          .where((b) => b.position?.toLowerCase() == "middle")
          .toList();

      if (middleList.isNotEmpty) {
        middleBanner = middleList.first;
      }

      final bottomList = allBanners
          .where((b) => b.position?.toLowerCase() == "bottom")
          .toList();

      if (bottomList.isNotEmpty) {
        bottomBanner = bottomList.first;
      }

    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }
}