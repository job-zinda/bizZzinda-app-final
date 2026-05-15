import 'package:flutter/material.dart';
import 'package:biz_zinda/Data/Network/network_api_service.dart';
import 'package:biz_zinda/Data/Network/network_controller.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/errorMsg.dart';
import 'package:biz_zinda/main.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view/login_section/otp_verify/repository/repository.dart';
import 'package:biz_zinda/view/login_section/phone_number_ui/repository/repository.dart';
import 'package:biz_zinda/view/login_section/referal_code/repository/repository.dart';
import 'package:go_router/go_router.dart';

class LoginPhoneNumberViewModel extends ChangeNotifier {
  FirebaseAuthServices services = FirebaseAuthServices();
  var otpRepo = OtpPageRepository(NetworkApiService());
  var repo = AddNewUserRepository(NetworkApiService());
  String signintype = "";
  bool checkbox = false;
  String? phoneNumber;
  String? countryCode;
  bool loading = false;
  String? error;
  String? verfiId;
  // String? email;
  int get phoneDigitCount => 10;
  final TextEditingController numberController = TextEditingController();

  List<String> get countryCodes => ['+91'];

  savePhoneNumber(String phone) {
    phoneNumber = phone;

    notifyListeners();
  }

  Future sendCode(BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          // if (form_key.currentState!.validate() == false) {
          //   throw 'Please check the field error';
          // }
          countryCode ??= countryCodes.first;
          print("country==${numberController.text}==$countryCode");

          loading = true;
          notifyListeners();
          services.signinWithPhone(
            '$countryCode${numberController.text}',
            verificationFailed: (val) {
              loading = false;
              notifyListeners();
              ErrorMsg.showSnakError(context,
                  val.message ?? 'Unable to send code to $phoneNumber');
            },
            codeSent: (verificationId, forceResendingToken) {
              loading = false;
              notifyListeners();
              verfiId = verificationId;
              context.pushNamed(PPages.otpPageUi, extra: this);
            },
            onAutoVerify: (user) {
              onVerifyOTp(context);
            },
          );

          // loading = false;
          // notifyListeners();
        } catch (e) {
          loading = false;
          error = e.toString();
          notifyListeners();
          ErrorMsg.showSnakError(navigatorKey.currentContext!, e.toString());
        }
      } else {
        navigatorKey.currentContext!.replaceNamed(PPages.noIntenet);
      }
    });
  }

  onVerifyOTp(BuildContext context) async {
    signintype = "phone";
    phoneNumber = numberController.text;
    print("dbnmsdbnmsbdnsdnsndb");
    var result = await otpRepo.checkProfile(
      phoneNumber!,
      countryCode!.split('+').last,
    );
    print(result['data']['userExists']);
    if (result['data']['userExists'] == false) {
      LoggedInUser.phoneNumber = phoneNumber;
      LoggedInUser.countryCode = countryCode!.split('+').last;
      // LoggedInUser.profile(
      //   phoneNumber!,
      //   countryCode!.split('+').last,
      //   "",
      //   "",
      //   "",
      // );
      // ignore: use_build_context_synchronously
      // Navigator.pushNamedAndRemoveUntil(
      //     context, PPages.adduserpage, (route) => false);
      context.pushNamed(PPages.adduserpage);
    } else {
      loginUser(context, "");
    }
  }

  loginUser(BuildContext context, String? email) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        var result;
        try {
          if (signintype == "phone") {
            result = await repo.addNewUser(
                phone: phoneNumber!,
                countryCode: countryCode!.split('+').last,
                name: '',
                referralCode: '');
          } else {
            result = await repo.addNewUserEmail(
                email: email!,
                phone: '',
                countryCode: '',
                name: '',
                referralCode: '');
          }

          print("User login-----------------${result['data']['user']}");

          LoggedInUser.login(result['data']);

          print(result['data']['user']['orgId']);
          print(result['data']['tokens']['access']['token']);
          print(result['data']['tokens']['refresh']['token']);

          // ignore: use_build_context_synchronously
          context.goNamed(PPages.loginSplashUi);
        } catch (e) {
          loading = false;
          notifyListeners();
          // ignore: use_build_context_synchronously
          print("e---$e");
          ErrorMsg.showSnakError(context, e.toString());
        }
      } else {
        context.replaceNamed(PPages.noIntenet);
      }
    });
  }

  checkUserExstsEmail(BuildContext context, String email) async {
    signintype = "email";
    print("checkProfileEmail----$email---$signintype");

    var result = await otpRepo.checkProfileEmail(email);
    print(result['data']['userExists']);
    if (result['data']['userExists'] == false) {
      LoggedInUser.email = email;
      // LoggedInUser.profile(
      //   phoneNumber!,
      //   countryCode!.split('+').last,
      //   "",
      //   "",
      //   "",
      // );
      // ignore: use_build_context_synchronously
      notifyListeners();
      context.pushNamed(PPages.adduserpage);
    } else {
      loginUser(context, email);
    }
  }
  // Future<void> initMobileNumberState() async {
  //   try {
  //     if (!await MobileNumber.hasPhonePermission) {
  //       await MobileNumber.requestPhonePermission;
  //       return;
  //     }

  //     String number = (await MobileNumber.mobileNumber)!;
  //     phoneNumber = number.substring(5);
  //     notifyListeners();
  //   } on PlatformException catch (e) {
  //     debugPrint("Failed to get mobile number because of '${e.message}'");
  //   }
  // }

  setCheckboxValue(bool value) {
    checkbox = value;
    notifyListeners();
  }
}
