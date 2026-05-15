// import 'dart:convert';

// import 'package:jora_customer/Data/Network/base_api_service.dart';
// import 'package:jora_customer/utils/api_url.dart';

// class AddNewUserRepository {
//   BaseApiService apiService;
//   AddNewUserRepository(this.apiService);

//   Future addNewUser({
//     required String phone,
//     required String countryCode,
//     required String referralCode,
//     String? name,
//   }) async {
//     try {
//       var result = await apiService.getPostApiResponse(
//         AppUrl.loginUrl,
//         body: {
//           'countryCode': countryCode,
//           'mobileNumber': phone,
//           'name': name,
//           'referralCode': referralCode
//         },
//       );
//       var json = jsonDecode(result);
//       if (json['status'] == false) {
//         throw json['message'];
//       }

//       print("add user----$json");
//       return json;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future addNewUserEmail({
//     String? phone,
//     String? countryCode,
//     required String email,
//     String? name,
//   }) async {
//     try {
//       print("ad nw user email------$countryCode---$phone---$name---$email");
//       var result = await apiService.getPostApiResponse(
//         AppUrl.loginEmail,
//         body: {
//           'countryCode': countryCode,
//           'mobileNumber': phone,
//           'name': name,
//           'email': email
//         },
//       );
//       var json = jsonDecode(result);
//       if (json['status'] == false) {
//         throw json['message'];
//       }

//       print("add user-- email--$json");
//       return json;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
