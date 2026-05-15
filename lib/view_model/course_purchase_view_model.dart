import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:biz_zinda/model/course_purchase_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CoursePurchaseViewModel extends ChangeNotifier {
  bool isLoading = false;
  CoursePurchaseModel? coursePurchase;

  Future<void> fetchCoursePurchase() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService().get(Api.baseurl + '/api/v1/course-purchase/my');
      if (response.statusCode == 200 && response.data['purchase'] != null) {
        coursePurchase = CoursePurchaseModel.fromJson(response.data['purchase']);
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCourseOrder({required Razorpay razorpay, required BuildContext context, String? referralCode}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService().post(
        Api.baseurl + '/api/v1/course-purchase/createOrder',
        {
          'userId': LoggedInUser.id,
          if (referralCode != null && referralCode.isNotEmpty) 'referralCode': referralCode,
        },
      );
      if (response.statusCode == 200 && response.data['order'] != null) {
        var order = response.data['order'];
        var options = {
          'key': order['key_id'],
          'amount': order['amount'],
          'order_id': order['id'],
          'name': 'Job Zinda',
          'description': 'Course Purchase',
        };
        razorpay.open(options);
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyCoursePayment({required String paymentId, required String orderId, required String razorpaySignature, required Razorpay razorpay, required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService().post(
        Api.baseurl + '/api/v1/course-purchase/verifyPayment',
        {
          'paymentId': paymentId,
          'orderId': orderId,
          'razorpay_signature': razorpaySignature,
          'userId': LoggedInUser.id,
        },
      );
      if (response.statusCode == 200 && response.data['purchase'] != null) {
        coursePurchase = CoursePurchaseModel.fromJson(response.data['purchase']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Verification Failed!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment error: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
