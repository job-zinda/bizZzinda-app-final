// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:jora_customer/model/logged_in_user.dart';
// import 'package:jora_customer/utils/api_service.dart';
// import 'package:jora_customer/utils/api_url.dart';
// import '../Settings/until/PPages.dart';

// class AuthViewModel with ChangeNotifier {
//   Future<void> login(
//       {required String phoneNumber, required BuildContext context}) async {
//     EasyLoading.show();
//     Response response = await ApiService()
//         .post(Api.loginUrl, {'countryCode': '91', 'mobileNumber': phoneNumber});
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = response.data;
//       log(response.data.toString());
//       if (data['status']) {
//         LoggedInUser.login(data['data']);
//         Navigator.pushNamedAndRemoveUntil(
//             context, PPages.loginSplashUi, (route) => false);
//       } else {
//         EasyLoading.dismiss();
//         EasyLoading.showError('User Not found');
//       }
//     }
//     EasyLoading.dismiss();
//   }
// }
