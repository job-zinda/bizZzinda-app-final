import 'dart:convert';

import 'package:biz_zinda/Data/Network/base_api_service.dart';
import 'package:biz_zinda/notification_service.dart';
import 'package:biz_zinda/utils/api_url.dart';

class AddNewUserRepository {
  BaseApiService apiService;
  AddNewUserRepository(this.apiService);

  Future addNewUser({
    required String phone,
    required String countryCode,
    required String referralCode,
    String? name,
    List<String>? skills,
  }) async {
    try {
      print("refeee-----$phone----$countryCode---${FCMService().fcmToken}--$name");
      var result = await apiService.getPostApiResponse(
        AppUrl.loginUrl,
         headers: {
          "fcm-token": FCMService().fcmToken??""
        },
        body: {
          'countryCode': countryCode,
          'mobileNumber': phone,
          'name': name,
          'referralCode': referralCode,
          'skills': skills ?? [],
        },
      );
      var json = jsonDecode(result);
      print("add user----$json");

      if (json['status'] == false) {
        throw json['message'];
      }

      return json;
    } catch (e) {
      rethrow;
    }
  }

  Future addNewUserEmail({
    String? phone,
    String? countryCode,
    required String email,
    required String referralCode,
    String? name,
    List<String>? skills,
  }) async {
    try {
      print(
          "ad nw user email------$countryCode---$phone---$name---$email---$referralCode");
      var result = await apiService.getPostApiResponse(
        AppUrl.loginEmail,
         headers: {
          "fcm-token": FCMService().fcmToken??""
        },
        body: {
          'countryCode': countryCode,
          'mobileNumber': phone,
          'name': name,
          'email': email,
          'referralCode': referralCode,
          'skills': skills ?? [],
        },
      );
      var json = jsonDecode(result);
      print("add user-- email--$json");

      // if (json['status'] == false) {
      //   throw json['message'];
      // }

      return json;
    } catch (e) {
      rethrow;
    }
  }
}
