import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../model/logged_in_user.dart';
import '../utils/api_service.dart';
import '../utils/api_url.dart';
import 'package:biz_zinda/view/store_location/store_model.dart';

class ConnectPageViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  String distanceInKm = "All"; // Default to "All" to show all stores by default
  String searchTag = "";

  String gender = "";
  String handledProjectsCountFrom = "";
  String projects = "";
  String rating = "";
  bool isMapReady = false;
  double? lat;
  double? lng;

  void updateDistanceInKm(String disKm) {
    distanceInKm = disKm;
    notifyListeners();
    fetchNearestStores();
  }

  void _zoomToTarget() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (isMapReady && lat != null && lng != null) {
        mapController.move(LatLng(lat!, lng!), 10);
      }
    });
  }

  void onMapReady() {
    isMapReady = true;
    notifyListeners();
  }

  void clear() {
    distanceInKm = "All";
    searchTag = "";
    gender = "";
    handledProjectsCountFrom = "";
    projects = "";
    rating = "";
    notifyListeners();
    fetchNearestStores();
  }

  void updateSearchTag(String search) {
    searchTag = search;
    notifyListeners();
    fetchNearestStores();
  }

  void updateDistanceInKm2(String disKm) {
    distanceInKm = disKm;
    notifyListeners();
  }

  void updateGender(String gen) {
    gender = gen;
    notifyListeners();
    fetchNearestStores();
  }

  void updateLocation(double? lattude, double? longitude) {
    lat = lattude;
    lng = longitude;
    debugPrint("Map location updated: lat=$lat, lng=$lng");
    fetchNearestStores();
    _zoomToTarget();
    notifyListeners();
  }

  void updateHandledProjectsCountFrom(String pro) {
    projects = pro;
    handledProjectsCountFrom = projects == "Any"
        ? "0"
        : projects == "More than 10"
            ? "10"
            : projects == "More than 50"
                ? "50"
                : "0";
    notifyListeners();
  }

  void updateRating(String rate) {
    rating = rate;
    notifyListeners();
  }

  List<StoreModel> nearestStores = [];

  Future<void> fetchNearestStores() async {
    if (lat == null || lng == null) return;

    EasyLoading.show();

    try {
      final endpoint = LoggedInUser.isGuest
          ? '/api/v1/store/public-nearest-stores'
          : '/api/v1/store/get-nearest-stores';

      final queryParams = <String, String>{
        'lat': lat.toString(),
        'lng': lng.toString(),
        'pageSize': '100',
      };

      if (distanceInKm.isNotEmpty && distanceInKm.toLowerCase() != 'all') {
        queryParams['distanceInKm'] = distanceInKm;
      }

      if (searchTag.trim().isNotEmpty) {
        queryParams['searchTag'] = searchTag.trim();
      }

      final uri = Uri.parse('${Api.baseurl}$endpoint')
          .replace(queryParameters: queryParams);

      Response response = await ApiService().get(uri.toString());

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        if (data['status'] == true) {
          List list = data['data']['profiles'] ?? [];
          nearestStores = list.map((e) => StoreModel.fromJson(e)).toList();
        } else {
          nearestStores.clear();
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error in fetchNearestStores: $e");
    }

    EasyLoading.dismiss();
  }
}

