import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Data/Network/network_api_service.dart';
import 'package:biz_zinda/Data/Network/network_controller.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/errorMsg.dart';
import 'package:biz_zinda/Settings/widgets/loadingShow.dart';
import 'package:biz_zinda/main.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view/login_section/referal_code/repository/repository.dart';

class AddReferalViewModel extends ChangeNotifier {
  var repo = AddNewUserRepository(NetworkApiService());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController referalController = TextEditingController();
  String? referralCode;
  String? name;

  bool loading = false;
  bool isError = false;

  addNewUser(
    BuildContext context,
  ) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          var result = await repo.addNewUser(
            phone: LoggedInUser.phoneNumber ?? '',
            countryCode: LoggedInUser.countryCode!.split('+').last,
            name: name,
            referralCode: referralCode!,
          );

          if (result['status'] == true) {
            LoggedInUser.login(result['data']);
            context.replaceNamed(PPages.loginSplashUi);
          } else {
            ErrorMsg.showSnakError(context, result['message']);
          }
        } catch (e) {
          print("Error in addNewUser: $e");
          ErrorMsg.showSnakError(context, "An error occurred: $e");
        } finally {
          loading = false;
          notifyListeners();
        }
      } else {
        context.replaceNamed(PPages.noIntenet);
      }
    });
  }
///////////////////////////////////////////////////////////////////
  addNewUserEmail(
      BuildContext context, String phone, String countryCode) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          loading = true;
          notifyListeners();
          print(
              "body----${LoggedInUser.email}---$phone--$name--$countryCode----$referralCode");

          // LoadingShow.load(context);
          var result = await repo.addNewUserEmail(
              phone: phone,
              email: LoggedInUser.email ?? '',
              countryCode: countryCode,
              referralCode: referralCode!,
              name: name);

          // LoadingShow.stopLoad(context);

          loading = false;
          notifyListeners();
          print("New User login----------------${result}");

          if (result['status'] == true) {
            LoggedInUser.login(result['data']);
            context.replaceNamed(PPages.loginSplashUi);
          } else {
            ErrorMsg.showSnakError(context, result['message']);
          }
        } catch (e) {
          isError = true;
          notifyListeners();
          if (isError) {
            LoadingShow.stopLoad(navigatorKey.currentContext!);
          }
          // ignore: use_build_context_synchronously
          // ErrorMsg.showSnakError(context, e.toString());
        }
      } else {
        navigatorKey.currentContext!.replaceNamed(PPages.noIntenet);
      }
    });
  }
}
