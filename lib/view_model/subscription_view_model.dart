import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
import 'package:biz_zinda/Data/Network/network_controller.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/main.dart' as main_app;
import 'package:biz_zinda/Settings/widgets/errorMsg.dart';
import 'package:biz_zinda/Settings/widgets/loadingShow.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/subscription_model.dart';
import 'package:biz_zinda/model/subscription_payment_model.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
// import 'package:dio/dio.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionViewmodel extends ChangeNotifier {
  List<Plans> planList = [];
  final Dio dio = Dio();
  bool isLoadingPlans = false;

  late Razorpay _razorpay;
  SubscriptionPaymentModel paymentOrderModel = SubscriptionPaymentModel();

  Future<void> fetchPlans() async {
    isLoadingPlans = true;
    notifyListeners();
    
    try {
      planList.clear();
      String url = "${Api.getPlans}?pageNumber=1&pageSize=10";
      Response response = await ApiService().get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        print("plan olist------$data");
        if (data['status']) {
          planList = (data['data']['plans'] as List)
              .map(
                (e) => Plans.fromJson(e),
              )
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching plans: $e");
    } finally {
      isLoadingPlans = false;
      notifyListeners();
    }
  }

  updateRazorpay(
      {required Razorpay razorpay,
      required BuildContext context,
      required String packageId}) {
    _razorpay = razorpay;
    createPackagePayment(context, packageId);
  }

  createPackagePayment(BuildContext context, String packageId) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          LoadingShow.load(context);
          Map body = {
            'planId': packageId,
          };
          Response response =
              await ApiService().post(Api.createSubscriptionPayment, body);
          print("subscription resposne--$body----${response.data}");
          if (response.statusCode == 200) {
            Map<String, dynamic> data = response.data;
            if (data['status']) {
              paymentOrderModel = SubscriptionPaymentModel.fromJson(
                  data['data']['subscription']);
                  print("sdhhsd----${paymentOrderModel.keyId}");
          if (paymentOrderModel.keyId != null) {
            openRazorPay();
          }
            } else {
              ErrorMsg.showSnakError(context, data['message']);
            }
          }

          

          // ignore: use_build_context_synchronously
          LoadingShow.stopLoad(context);
        } catch (e, stack) {
          print(stack);
          print(
              "Issue Razerpay:--------------------------- ----  ${e.toString()} ------");
          LoadingShow.stopLoad(context);
          // ignore: use_build_context_synchronously
          ErrorMsg.showSnakError(context, e.toString());
        }
      } else {
        context.replaceNamed(PPages.noIntenet);
      }
    });
  }

  void openRazorPay(
      // {required int amount, required Razorpay razorpay}
      ) async {
    double payAmount = paymentOrderModel.amount! * 100;

    print("payamount---${payAmount}");
    var options = {
      'key': paymentOrderModel.keyId!,
      'amount': payAmount,
      'order_id': paymentOrderModel.id!,
      'name': paymentOrderModel.notes!.fullName,
      'description': 'Subscription Payment',
      'prefill': {
        'contact': paymentOrderModel.notes!.phone!,
        'email': paymentOrderModel.notes!.email!,
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("Razor Pay Issue: ----------------- $e ---=");
    }
  }

  verifyPackagePayment({
    required BuildContext context,
    required String orderId,
    required String paymentId,
    required String razorpay_signature,
  }) async {
    EasyLoading.show(status: 'Verifying Payment...');
    try {
      Map<String, dynamic> headers = {
        "x-razorpay-signature": razorpay_signature,
        'Authorization': "Bearer ${LoggedInUser.accessToken}",
      };
      Map body = {'orderId': orderId, 'paymentId': paymentId};
      Response response = await dio.post(
        Api.verifySubscriptionPayment,
        data: body,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        if (data['status']) {
          EasyLoading.showSuccess("Payment Successful!");
          await fetchPlans();
          await context.read<ProfileViewModel>().fetchProfile();
          if (context.mounted) {
            context.pushNamed(PPages.freeLancerEditProfileUi);
          }
        } else {
          EasyLoading.showError(data['message'] ?? 'Payment Verification Failed');
        }
        notifyListeners();
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
