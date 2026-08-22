import 'package:flutter/material.dart';
import '../../../../../model/banners_model.dart';
import '../../../../../model/logged_in_user.dart';
import '../../../../../utils/api_service.dart';
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

      List<dynamic> bannerList = [];
      final bool hasToken = LoggedInUser.accessToken != null &&
          LoggedInUser.accessToken!.isNotEmpty &&
          !LoggedInUser.isGuest;

      if (hasToken) {
        try {
          final response = await ApiService().get(Api.listBanners);
          final data = response.data;
          if (data is Map<String, dynamic> &&
              data['data'] != null &&
              data['data']['banners'] is List) {
            bannerList = data['data']['banners'] as List;
          }
        } catch (e) {
          print('[BannerViewModel biz] Error fetching user banners: $e');
        }
      }

      // If user banners are empty or user is guest, fallback to public banners
      if (bannerList.isEmpty) {
        try {
          final response = await ApiService().get(Api.publicBannersUrl);
          final data = response.data;
          if (data is Map<String, dynamic> &&
              data['data'] != null &&
              data['data']['banners'] is List) {
            bannerList = data['data']['banners'] as List;
          }
        } catch (e) {
          print('[BannerViewModel biz] Error fetching public banners: $e');
        }
      }

      List<Banners> allBanners = bannerList
          .map((e) => Banners.fromJson(
              e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e)))
          .toList();

      topBanners = allBanners
          .where((b) => (b.position ?? '').toLowerCase() == 'top')
          .toList();

      final middleList = allBanners
          .where((b) => (b.position ?? '').toLowerCase() == 'middle')
          .toList();
      middleBanner = middleList.isNotEmpty ? middleList.first : null;

      final bottomList = allBanners
          .where((b) => (b.position ?? '').toLowerCase() == 'bottom')
          .toList();
      bottomBanner = bottomList.isNotEmpty ? bottomList.first : null;

      print('[BannerViewModel biz] Loaded ${topBanners.length} top banners, ${allBanners.length} total banners.');
    } catch (e, stack) {
      print('[BannerViewModel biz] getBanners fatal error: $e\n$stack');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
