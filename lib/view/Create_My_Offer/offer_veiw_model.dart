import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view/Create_My_Offer/offermodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';



class OfferViewModel with ChangeNotifier {
  String? selectedCity;
  String? selectedState;
  String? offeringId;
  Position? pos;

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showError("Enable location service");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showError("Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      EasyLoading.showError("Location permanently denied");
      return;
    }

    pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    notifyListeners(); // 🔥 IMPORTANT
  }


  /// 🔹 MEDIA VARIABLES
  String? selectedUrl;
  String? selectedMediaType;
  String? selectedThumbnailUrl;
  dynamic selectedThumbanilFile;


  /// 🔹 CATEGORY FILTER
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;
  set selectedCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  /// 🔹 PAGINATION CONTROLLER
  final PagingController<int, OfferingModel> _offerController =
  PagingController(firstPageKey: 1);

  PagingController<int, OfferingModel> get offerController => _offerController;

  /// 🔹 CONSTRUCTOR
  OfferViewModel() {
    _offerController.addPageRequestListener((pageKey) {
      fetchOffers(pageKey);
    });
  }

  /// 🔹 REFRESH
  Future<void> refreshOffer() async {
    _offerController.refresh();
  }


  /// 🔹 CREATE-OFFER IN-FLIGHT GUARD
  bool _isCreating = false;

  bool get isCreating => _isCreating;

  Future<void> createOffer({
    required String description,
    required String city,
    required String state,
    String? category,
    required BuildContext context,
  }) async {
    /// Ignore repeat taps while a create is already running. The backend also
    /// rejects duplicates with a 409, but this stops the second request being
    /// sent at all — so an impatient double-tap never surfaces as an error.
    if (_isCreating) return;

    _isCreating = true;
    notifyListeners();

    EasyLoading.show(status: "Creating...");

    try {
      /// 🔹 GET LOCATION
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final body = {
        "mediaType": selectedMediaType ?? "image",
        "mediaUrl": selectedUrl,
        "thumbnail": selectedThumbnailUrl ?? "",
        "bio": description,
        "city": selectedCity,
        "state": selectedState,
        "category": category,
        "latitude": pos.latitude,
        "longitude": pos.longitude,
      };

      Response response = await ApiService().post(
        "${Api.baseurl}/api/v1/offering/addOffering",
        body,
      );

      EasyLoading.dismiss();

      if (response.data['status'] == true) {
        EasyLoading.showSuccess("Offer Created");


        selectedUrl = null;
        selectedMediaType = null;
        selectedThumbnailUrl = null;
        selectedThumbanilFile = null;

        notifyListeners();

        _offerController.refresh();

        await Future.delayed(const Duration(milliseconds: 500));

        Navigator.pop(context, true);
      } else {
        /// Covers the 409 duplicate response — ApiService sets
        /// `validateStatus: (status) => true`, so the body arrives here rather
        /// than as a thrown DioException, and `message` carries the reason.
        EasyLoading.showError(response.data['message'] ?? "Failed");
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error: $e");
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }


  // Future<void> fetchOffers(int page) async {
  //   try {
  //     print("📡 CALLING OFFER API PAGE: $page");
  //
  //       Response response = await ApiService().get(
  //       "${Api.listMyOfferings}?pageNumber=$page",
  //     );
  //
  //     print("✅ RESPONSE: ${response.data}");
  //     print("📦 OFFERS: ${response.data['data']['offerings']}");
  //     print("📡 CALLING OFFER API PAGE: $page");
  //     print("URL: ${Api.listMyOfferings}?pageNumber=$page");
  //
  //     if (response.statusCode == 200 &&
  //         response.data['status'] == true) {
  //       offeringId = response.data['data']['_id'];
  //       print("🔥 OFFER ID: $offeringId");
  //
  //       List list = response.data['data']['offerings'];
  //
  //       final offers =
  //       list.map((e) => OfferingModel.fromJson(e)).toList();
  //
  //       final isLastPage =
  //       !(response.data['data']['hasNext'] ?? false);
  //
  //       if (isLastPage) {
  //         _offerController.appendLastPage(offers);
  //       } else {
  //         final nextPageKey = page + 1;
  //         _offerController.appendPage(offers, nextPageKey);
  //       }
  //     } else {
  //       _offerController.appendLastPage([]);
  //     }
  //
  //   } catch (e) {
  //     print("❌ ERROR: $e");
  //     _offerController.error = e;
  //   }
  // }
  Future<bool> likeOffering(String offeringId) async {
    try {
      Response response = await ApiService().post(
        Api.toggleLikeOffer, //
        {
          "offeringId": offeringId,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Like error: $e");
      return false;
    }
  }

  Future<void> fetchOffers(int page) async {
    try {
      print("📡 CALLING ALL OFFER API PAGE: $page");

      final url = LoggedInUser.isGuest
          ? "${Api.baseurl}/api/v1/offering/public-offerings"
          : "${Api.baseurl}/api/v1/offering/listAllOfferings";

      final headers = LoggedInUser.isGuest
          ? <String, String>{}
          : await LoggedInUser.getAuthorizationHeader();

      final Map<String, dynamic> queryParams = {
        "pageNumber": page,
        "pageSize": 10,
      };

      if (_selectedCategory != null &&
          _selectedCategory!.isNotEmpty &&
          _selectedCategory != 'All') {
        queryParams["category"] = _selectedCategory;
      }

      Response response = await Dio().get(
        url,
        queryParameters: queryParams,
        options: Options(headers: {
          ...headers,
          "X-Platform": "bizzzinda",
        }),
      );

      print("✅ RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data['data'];

        List list = data['offerings'] ?? data['posts'] ?? [];

        final offers =
        list.map((e) => OfferingModel.fromJson(e)).toList();

        final isLastPage = !(data['hasNext'] ?? false);

        if (isLastPage) {
          _offerController.appendLastPage(offers);
        } else {
          final nextPageKey = page + 1;
          _offerController.appendPage(offers, nextPageKey);
        }
      } else {
        _offerController.appendLastPage([]);
      }
    } catch (e) {
      print("❌ ERROR: $e");
      _offerController.error = e;
    }
  }
  Future<int?> increaseShareCount(String offeringId) async {
    try {
      Response response = await ApiService().post(
        Api.shareOffering,
        {
          "offeringId": offeringId,
        },
      );

      if (response.statusCode == 200 &&
          response.data['status'] == true) {
        return response.data['data']['shareCount'];
      }
    } catch (e) {
      print("Share count error: $e");
    }
    return null;
  }

  /// 🔹 DELETE OFFER
  Future<void> removeOffer({
    required String offerId,
    required BuildContext context,
  }) async {
    EasyLoading.show(status: "Deleting...");

    try {
      Response response = await ApiService().delete(
        "${Api.baseurl}/api/v1/offering/removeMyOffering/$offerId",
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.data['status'] == true) {

        refreshOffer();

        EasyLoading.showSuccess(response.data['message']);
      } else {
        EasyLoading.showError(
            response.data['message'] ?? "Failed to delete offer");
      }

    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Failed to delete offer");
    }
  }

  Future<void> promoteOffer(String offerId) async {
    try {
      EasyLoading.show(status: "Promoting...");

      final response = await ApiService().post(
        "${Api.baseurl}/api/v1/offer-promotion/promote",
        {
          "offeringId": offerId,
        },
      );

      EasyLoading.dismiss();
      EasyLoading.showSuccess("Promoted Successfully");

    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Failed");
    }
  }
  Future<Map<String, dynamic>?> initiatePromotion(String offerId) async {
    try {
      EasyLoading.show(status: "Processing...");

      Response response = await ApiService().post(
        "${Api.baseurl}/api/v1/offer-promotion/promote",
        {
          "offeringId": offerId,
        },
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic>) {
          if (resData['status'] == false) {
            String errorMsg = resData['message'] ?? resData['error'] ?? "Failed";
            EasyLoading.showError(errorMsg);
            return null;
          }
          if (resData['data'] != null && resData['data'] is Map<String, dynamic>) {
            return resData['data'] as Map<String, dynamic>;
          }
          if (resData['order'] != null && resData['order'] is Map<String, dynamic>) {
            return resData['order'] as Map<String, dynamic>;
          }
          return resData;
        }
        return null;
      } else {
        final resData = response.data;
        String msg = "Failed (${response.statusCode})";
        if (resData is Map<String, dynamic>) {
          msg = resData['message'] ?? resData['error'] ?? resData['msg'] ?? "Failed (${response.statusCode})";
        }
        EasyLoading.showError(msg);
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error: $e");
      return null;
    }
  }

  Future<void> verifyPromotionPayment({
    required String orderId,
    required String paymentId,
  }) async {
    try {
      EasyLoading.show(status: "Verifying...");

      Response response = await ApiService().post(
        "${Api.baseurl}/api/v1/offer-promotion/verify-promote-payment",
        {
          "orderId": orderId,
          "paymentId": paymentId,
        },
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = response.data;
        if (resData is Map<String, dynamic> && resData['status'] == false) {
          EasyLoading.showError(resData['message'] ?? resData['error'] ?? "Verification failed");
        } else {
          EasyLoading.showSuccess("Promotion Successful 🎉");
        }
      } else {
        final resData = response.data;
        String msg = "Verification failed";
        if (resData is Map<String, dynamic>) {
          msg = resData['message'] ?? resData['error'] ?? "Verification failed (${response.statusCode})";
        }
        EasyLoading.showError(msg);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Error: $e");
    }
  }
}