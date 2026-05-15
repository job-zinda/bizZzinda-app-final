import 'package:dio/dio.dart';

class StoreSubscriptionService {
  final Dio dio;

  StoreSubscriptionService(this.dio) {
    dio.options.baseUrl = "https://server2.jobzinda.com";
  }

  Options _headers(String token) {
    return Options(
      headers: {
        'x-platform': 'bizzzinda',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<List<dynamic>> getPlans(String token) async {
    try {
      final response = await dio.get(
        "/api/v1/subscription/listSubscriptionPlans",
        queryParameters: {"platform": "bizzzinda"},
        options: _headers(token),
      );

      print("✅ PLANS API: ${response.data}");

      return response.data['data']?['plans'] ?? [];
    } catch (e) {
      print("❌ getPlans error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> createSubscription({
    required String token,
    required String planId,
    required String userId,
  }) async {
    try {
      final response = await dio.post(
        "/api/v1/subscription/addSubscription",
        data: {
          "planId": planId,
          "userId": userId,
        },
        options: _headers(token),
      );

      return response.data['data'];
    } catch (e) {
      print("❌ Create Subscription Error: $e");
      return null;
    }
  }
  Future<Map<String, dynamic>?> createOrder({
    required String token,
    required int amount,
  }) async {
    try {
      final response = await dio.post(
        "/api/v1/payment/createOrder", // ⚠️ backend confirm cheyyu
        data: {
          "amount": amount,
        },
        options: _headers(token),
      );

      return response.data['data'];
    } catch (e) {
      print("❌ Create Order Error: $e");
      return null;
    }
  }
  Future<bool> verifyPayment({
    required String token,
    required String orderId,
    required String paymentId,
    required String signature,
    required String userId,
  }) async {
    try {
      final response = await dio.post(
        "/api/v1/subscription/verifyPayment",
        data: {
          "orderId": orderId,
          "paymentId": paymentId,
          "signature": signature,
          "userId": userId,
        },
        options: _headers(token),
      );

      return response.data['status'] == true;
    } catch (e) {
      print("❌ Verify Error: $e");
      return false;
    }
  }
}