import 'dart:convert';
import 'dart:developer' as dev;

import '../Data/Network/network_api_service.dart';
import '../utils/api_url.dart';



class AuthUsernameService {
  final NetworkApiService _net;
  AuthUsernameService(this._net);

  Future<Map<String, dynamic>> loginWithUsername({
    required String username,
    required String password,
  }) async {
    final resp = await _net.getPostApiResponse(
      AppUrl.loginUsername,
      body: {
        'username': username,
        'password': password,
      },
    );
    return jsonDecode(resp as String) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> passwordSetupStatus({
    required String countryCode,
    required String mobileNumber,
  }) async {
    final resp = await _net.getPostApiResponse(
      AppUrl.passwordSetupStatus,
      body: {
        'countryCode': countryCode,
        'mobileNumber': mobileNumber,
      },
    );
    final map = jsonDecode(resp as String) as Map<String, dynamic>;
    final ok = map['status'] == true || map['success'] == true;
    if (!ok) {
      dev.log('passwordSetupStatus error: ${map['message']}', name: 'AuthUsernameService');
      throw Exception((map['message'] ?? 'Unable to check password setup status').toString());
    }
    return map;
  }

  Future<Map<String, dynamic>> otpVerifyInitPassword({
    required String idToken,
    required String countryCode,
    required String mobileNumber,
    required String username,
    required String password,
    String? confirmPassword,
  }) async {
    final resp = await _net.getPostApiResponse(
      AppUrl.otpVerifyInitPassword,
      headers: {
        'id-token': idToken,
      },
      body: {
        'countryCode': countryCode,
        'mobileNumber': mobileNumber,
        'username': username,
        'password': password,
        if (confirmPassword != null) 'confirmPassword': confirmPassword,
      },
    );
    final map = jsonDecode(resp as String) as Map<String, dynamic>;
    final ok = map['status'] == true || map['success'] == true;
    if (!ok) {
      dev.log('otpVerifyInitPassword error: ${map['message']}', name: 'AuthUsernameService');
      throw Exception((map['message'] ?? 'OTP verification failed').toString());
    }
    return map;
  }

  Future<Map<String, dynamic>> otpVerifyChangePassword({
    required String idToken,
    required String countryCode,
    required String mobileNumber,
    required String newPassword,
    String? confirmPassword,
  }) async {
    final resp = await _net.getPostApiResponse(
      AppUrl.otpVerifyChangePassword,
      headers: {
        'id-token': idToken,
      },
      body: {
        'countryCode': countryCode,
        'mobileNumber': mobileNumber,
        'newPassword': newPassword,
        if (confirmPassword != null) 'confirmPassword': confirmPassword,
      },
    );
    final map = jsonDecode(resp as String) as Map<String, dynamic>;
    final ok = map['status'] == true || map['success'] == true;
    if (!ok) {
      throw Exception((map['message'] ?? 'OTP verification failed').toString());
    }
    return map;
  }

  Future<Map<String, dynamic>> registerAfterOtp({
    required String idToken,
    required String countryCode,
    required String mobileNumber,
    required String username,
    required String password,
    required String name,
    required String professionId,
    required String profession,
    required bool getNotifications,
    required double lat,
    required double lng,
    List<String>? skills,
    String? deviceId,
    String? email,
    String? referralCode,
    String? contactNumber,
    String? whatsappNumber,
  }) async {

    final body = <String, dynamic>{
      'countryCode': countryCode,
      'mobileNumber': mobileNumber,
      'username': username,
      'password': password,
      'name': name,
      'professionId': professionId,
      'profession': profession,
      'getNotifications': getNotifications,
      'lat': lat,
      'lng': lng,
      if (skills != null) 'skills': skills,
      if (deviceId != null) "deviceId": deviceId,
      if (contactNumber != null) 'contactNumber': contactNumber,
      if (whatsappNumber != null) 'whatsappNumber': whatsappNumber,
    };
    if (email != null) body['email'] = email;
    if (referralCode != null) body['referralCode'] = referralCode;

    final resp = await _net.getPostApiResponse(
      AppUrl.registerAfterOtp,
      headers: {
        'id-token': idToken,
      },
      body: body,
    );
    final map = jsonDecode(resp as String) as Map<String, dynamic>;
    final ok = map['status'] == true || map['success'] == true;
    if (!ok) {
      dev.log('registerAfterOtp error: ${map['message']}', name: 'AuthUsernameService', error: map);
      throw Exception((map['message'] ?? 'Registration failed').toString());
    }
    return map;
  }

  Future<Map<String, dynamic>> registerWithUsername({
    required String countryCode,
    required String mobileNumber,
    required String username,
    required String password,
    required String name,
    String? professionId,
    String? profession,
    bool getNotifications = true,
    double lat = 0,
    double lng = 0,
    List<String>? skills,
    String? deviceId,
    String? email,
    String? referralCode,
    String? contactNumber,
    String? whatsappNumber,
  }) async {
    final body = <String, dynamic>{
      'countryCode': countryCode,
      'mobileNumber': mobileNumber,
      'username': username,
      'password': password,
      'name': name,
      'professionId': professionId ?? '',
      'profession': profession ?? '',
      'getNotifications': getNotifications,
      'lat': lat,
      'lng': lng,
      if (skills != null) 'skills': skills,
      if (deviceId != null) "deviceId": deviceId,
      if (contactNumber != null) 'contactNumber': contactNumber,
      if (whatsappNumber != null) 'whatsappNumber': whatsappNumber,
    };
    if (email != null) body['email'] = email;
    if (referralCode != null && referralCode.isNotEmpty) body['referralCode'] = referralCode;

    final resp = await _net.getPostApiResponse(
      AppUrl.registerUsername,
      body: body,
    );
    return jsonDecode(resp as String) as Map<String, dynamic>;
  }

  // =========================
  // ✅ NEW: SEND EMAIL OTP
  // =========================

  Future<Map<String, dynamic>> sendEmailOtp({
    required String email,
  }) async {

    final resp = await _net.getPostApiResponse(
      AppUrl.sendEmailOtp,
      body: {
        'email': email,
      },
    );

    final map = jsonDecode(resp as String) as Map<String, dynamic>;
    final ok = map['status'] == true || map['success'] == true;

    if (!ok) {
      dev.log(
        'sendEmailOtp error: ${map['message']}',
        name: 'AuthUsernameService',
      );
      throw Exception(
        (map['message'] ?? 'Failed to send OTP').toString(),
      );
    }

    return map;
  }

  // =========================
  // ✅ NEW: VERIFY EMAIL OTP
  // =========================

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {

    final resp = await _net.getPostApiResponse(
      AppUrl.verifyEmailOtp,
      body: {
        'email': email,
        'otp': otp,
      },
    );

    final map = jsonDecode(resp as String) as Map<String, dynamic>;
    final ok = map['status'] == true || map['success'] == true;

    if (!ok) {
      dev.log(
        'verifyEmailOtp error: ${map['message']}',
        name: 'AuthUsernameService',
      );
      throw Exception(
        (map['message'] ?? 'OTP verification failed').toString(),
      );
    }

    return map;
  }
}