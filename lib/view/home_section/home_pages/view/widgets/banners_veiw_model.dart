import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../../model/banners_model.dart';
import '../../../../../model/logged_in_user.dart';
import '../../../../../utils/api_url.dart';

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

      final url = LoggedInUser.isGuest
          ? Api.publicBannersUrl
          : Api.listBanners;
      final response = await dio.get(url);

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