import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

import '../utils/api_service.dart';
import '../utils/api_url.dart';
import 'package:biz_zinda/view/store_location/store_model.dart';

class ConnectPageViewModel extends ChangeNotifier {

  final MapController mapController = MapController();
  String distanceInKm = "10";
  String searchTag = "";

  String gender = "";
  String handledProjectsCountFrom = "";
  String projects = "";
  String rating = "";
  bool isMapReady = false;
  double? lat;
  double? lng;

  updateDistanceInKm(String disKm) {
    distanceInKm = disKm;
    notifyListeners();
    fetchNearestStores();
  }

  void _zoomToTarget() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (isMapReady) {
        mapController.move(LatLng(lat!, lng!), 10);
      } 
    });
  }

  void onMapReady() {
    isMapReady = true;
    notifyListeners();
  }

  clear() {
    distanceInKm = "10";
    searchTag = "";
    gender = "";
    handledProjectsCountFrom = "";
    projects = "";
    // lat=navigatorKey.currentContext!.read<ProfileViewModel>().profileModel.lat!;
    // lng=navigatorKey.currentContext!.read<ProfileViewModel>().profileModel.lng!;

    rating = "";
    notifyListeners();
    fetchNearestStores();
  }

  updateSearchTag(String search) {
    searchTag = search;
    notifyListeners();
    fetchNearestStores();
  }

  updateDistanceInKm2(String disKm) {
    distanceInKm = disKm;
    notifyListeners();
  }

  updateGender(String gen) {
    gender = gen;
    notifyListeners();
    fetchNearestStores();
  }

  updateLocation(double? lattude, double? longitude) {
    lat = lattude;
    lng = longitude;
    print("my lat----$lat---$lng");
    fetchNearestStores();
    _zoomToTarget();
    notifyListeners();
  }

  updateHandledProjectsCountFrom(String pro) {
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

  updateRating(String rate) {
    rating = rate;
    notifyListeners();
  }

  List<StoreModel> nearestStores = [];

  Future<void> fetchNearestStores() async {
    if (lat == null || lng == null) return;

    EasyLoading.show();

    try {
      Response response = await ApiService().get(
        '/api/v1/store/get-nearest-stores?lat=$lat&lng=$lng',
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        if (data['status'] == true) {
          List list = data['data']['profiles'] ?? [];

          nearestStores =
              list.map((e) => StoreModel.fromJson(e)).toList();
        } else {
          nearestStores.clear();
        }

        notifyListeners();
      }
    } catch (e) {
      print("Error: $e");
    }

    EasyLoading.dismiss();
  }
}
