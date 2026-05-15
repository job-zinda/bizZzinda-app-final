// import 'package:flutter/material.dart';
// import 'package:jora_customer/Data/Network/network_api_service.dart';
// import 'package:jora_customer/Data/Network/network_controller.dart';
// import 'package:jora_customer/Settings/until/PPages.dart';
// import 'package:jora_customer/Settings/widgets/loadingShow.dart';
// import 'package:jora_customer/main.dart';
// import 'package:jora_customer/model/logged_in_user.dart';
// import 'package:jora_customer/view/login_section/add_newuser/repository/repository.dart';
// import 'package:jora_customer/view/login_section/referal_code/repository/repository.dart';

// class AddNewUserViewModel extends ChangeNotifier {
//   AddNewUserViewModel();
//   var repo = AddNewUserRepository(NetworkApiService());

//   // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   String? name;

//   bool loading = false;
//   bool isError = false;

//   // addNewUser(BuildContext context) async {
//   //   NetConnection.networkConnection(context).then((value) async {
//   //     if (value == true) {
//   //       try {
//   //         loading = true;
//   //         notifyListeners();
//   //         print(
//   //             "body----${LoggedInUser.phoneNumber}---${LoggedInUser.countryCode!}---$name");

//   //         // LoadingShow.load(context);
//   //         var result = await repo.addNewUser(
//   //             phone: LoggedInUser.phoneNumber ?? '',
//   //             countryCode: LoggedInUser.countryCode!.split('+').last,
//   //             name: name,
//   //             referralCode: 
//   //             );

//   //         // LoadingShow.stopLoad(context);
//   //         LoggedInUser.login(result['data']);
//   //         // LoggedInUser.profile(
//   //         //   LoggedInUser.phoneNumber,
//   //         //   LoggedInUser.countryCode,
//   //         //   result['data']['tokens']['access']['token'],
//   //         //   result['data']['tokens']['refresh']['token'],
//   //         //   result['data']['user']['orgId'],
//   //         // );
//   //         loading = false;
//   //         notifyListeners();
//   //         print("New User login-----------------Succuss");

//   //         print(result['data']['tokens']['access']['token']);
//   //         print(result['data']['tokens']['refresh']['token']);

//   //         // ignore: use_build_context_synchronously
//   //         Navigator.pushNamed(
//   //           navigatorKey.currentContext!,
//   //           PPages.loginSplashUi,
//   //         );
//   //       } catch (e) {
//   //         isError = true;
//   //         notifyListeners();
//   //         if (isError) {
//   //           LoadingShow.stopLoad(navigatorKey.currentContext!);
//   //         }
//   //         // ignore: use_build_context_synchronously
//   //         // ErrorMsg.showSnakError(context, e.toString());
//   //       }
//   //     } else {
//   //       Navigator.pushReplacementNamed(context, PPages.noIntenet);
//   //     }
//   //   });
//   // }

//   // addNewUserEmail(
//   //     BuildContext context, String phone, String countryCode) async {
//   //   NetConnection.networkConnection(context).then((value) async {
//   //     if (value == true) {
//   //       try {
//   //         loading = true;
//   //         notifyListeners();
//   //         print("body----${LoggedInUser.email}---$phone--$name--$countryCode");

//   //         // LoadingShow.load(context);
//   //         var result = await repo.addNewUserEmail(
//   //             phone: phone,
//   //             email: LoggedInUser.email ?? '',
//   //             countryCode: countryCode,
//   //             name: name);

//   //         // LoadingShow.stopLoad(context);
//   //         LoggedInUser.login(result['data']);

//   //         loading = false;
//   //         notifyListeners();
//   //         print("New User login-----------------Succuss");

//   //         // print(result['data']['tokens']['access']['token']);
//   //         // print(result['data']['tokens']['refresh']['token']);

//   //         // ignore: use_build_context_synchronously
//   //         Navigator.pushNamed(
//   //           navigatorKey.currentContext!,
//   //           PPages.loginSplashUi,
//   //         );
//   //       } catch (e) {
//   //         isError = true;
//   //         notifyListeners();
//   //         if (isError) {
//   //           LoadingShow.stopLoad(navigatorKey.currentContext!);
//   //         }
//   //         // ignore: use_build_context_synchronously
//   //         // ErrorMsg.showSnakError(context, e.toString());
//   //       }
//   //     } else {
//   //       Navigator.pushReplacementNamed(
//   //           navigatorKey.currentContext!, PPages.noIntenet);
//   //     }
//   //   });
//   // }
// }
