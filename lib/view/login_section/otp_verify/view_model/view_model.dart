import 'package:flutter/material.dart';
import 'package:biz_zinda/Data/Network/network_api_service.dart';
import 'package:biz_zinda/Data/Network/network_controller.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/errorMsg.dart';
import 'package:biz_zinda/view/login_section/otp_verify/repository/repository.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/view_model/view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpPageViewModel extends ChangeNotifier {
  LoginPhoneNumberViewModel loginModel;
  OtpPageViewModel(this.loginModel);

  var repo = OtpPageRepository(NetworkApiService());

  String? otp;
  bool loading = false;

  Future verifyOtp(BuildContext context) async {
    if (otp == null || otp!.isEmpty) {
      ErrorMsg.showSnakError(context, 'Please enter the OTP sent to your phone.');
      return;
    }
    if (otp!.length != 6) {
      ErrorMsg.showSnakError(context, 'The OTP is invalid. Please ensure it is a 6-digit number.');
      return;
    }
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          int.parse(otp!);
        } catch (e) {
          ErrorMsg.showSnakError(context, 'The OTP is invalid. Please ensure it is a 6-digit number.');
          return;
        }
        loading = true;
        notifyListeners();
        loginModel.services.verifyOtp(otp!, loginModel.verfiId!).then((value) {
          loginModel.onVerifyOTp(context);
        }).onError((error, stackTrace) {
          loading = false;
          notifyListeners();
          print('--- OTP Verification Error ---');
          print('Error Type: ${error.runtimeType}');
          print('Error: ${error.toString()}');
          if (error is FirebaseAuthException) {
            print('Firebase Auth Error Code: ${error.code}');
            print('Firebase Auth Error Message: ${error.message}');
          }
          print('Stack Trace: ${stackTrace.toString()}');
          print('-----------------------------');
          ErrorMsg.showSnakError(context, "The OTP could not be verified. Please check the OTP or request a new one.");
        });
      } else {
        Navigator.pushReplacementNamed(context, PPages.noIntenet);
      }
    });
  }
}
