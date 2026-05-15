import 'package:biz_zinda/Settings/until/PPages.dart' show PPages;
import 'package:biz_zinda/services/store_subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late Razorpay _razorpay;
  late StoreSubscriptionService service;
  String userPhone = "";
  String userEmail = "";
  List plans = [];
  bool isLoading = true;
  String token = "";
  String userId = "";
  void handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: ${response.message}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Failed ❌"),
      ),
    );
  }
  void handleExternalWallet(ExternalWalletResponse response) {
    print("WALLET: ${response.walletName}");
  }

  void openPaymentGateway(Map<String, dynamic> order) {

    print("ORDER => $order");

    var options = {
      'key': order['key_id'],
      'amount': order['amount'] * 100,
      'currency': 'INR',
      'order_id': order['orderId'],
      'name': 'BizzZinda',
      'description': 'Subscription',
      'prefill': {
        'contact': userPhone,
        'email': userEmail,
      }
    };

    print("OPTIONS => $options");

    try {
      _razorpay.open(options);
    } catch (e) {
      print("RAZORPAY ERROR => $e");
    }
  }
  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("SUCCESS: ${response.paymentId}");

    final success = await service.verifyPayment(
      token: token,
      orderId: response.orderId!,
      paymentId: response.paymentId!,
      signature: response.signature!,
      userId: userId,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Verified 🎉"),
        ),
      );

      context.goNamed(PPages.editProfileUi);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification Failed ❌"),
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    service =  StoreSubscriptionService(Dio());
    loadUser();

  }
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
  Future loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString('bizzzinda_accessToken') ?? "";
    userId = prefs.getString('bizzzinda_id') ?? "";
    userPhone = prefs.getString('phone') ?? "";
    userEmail = prefs.getString('email') ?? "";

    print("PHONE => $userPhone");
    print("EMAIL => $userEmail");

    print("TOKEN: $token");
    print("USER ID: $userId");

    if (token.isEmpty) {
      print("❌ Token missing");
      return;
    }

    service = StoreSubscriptionService(
      Dio(BaseOptions(
        baseUrl: "https://server2.jobzinda.com",
      )),
    );

    loadPlans();
  }

  Future loadPlans() async {
    try {
      final data = await service.getPlans(token);
      setState(() {
        plans = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading plans: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🟢 Create Subscription
  Future createSubscription(String planId) async {
    try {

      final response = await Dio(
        BaseOptions(
          baseUrl: "https://server2.jobzinda.com",
        ),
      ).post(
        "/api/v1/subscription/addSubscription",
        data: {
          "planId": planId,
          "userId": userId,
        },
        options: Options(
          headers: {
            'x-platform': 'bizzzinda',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("FULL RESPONSE => ${response.data}");

      final data = response.data['data'];

      if (data == null) {
        print("DATA NULL");
        return;
      }

      // 🔥 order object
      final order = data['order'];

      if (order == null) {
        print("ORDER NULL");
        return;
      }

      final orderId = order['id'];
      final amount = order['amount'];

      print("ORDER ID => $orderId");
      print("AMOUNT => $amount");

      // 🔥 open razorpay
      openPaymentGateway({
        "orderId": orderId,
        "amount": amount,

      });

    } catch (e) {
      print("CREATE SUBSCRIPTION ERROR => $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subscription Failed ❌"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Plans"),
      ),
    body: isLoading
    ? const Center(child: CircularProgressIndicator())
        : plans.isEmpty
    ? const Center(child: Text("No Plans Available"))
      : ListView.builder(
      itemCount: plans.length,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, index) {
        final plan = plans[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18), // 🔥 bigger padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // 🔹 TITLE (bigger)
                  Text(
                    plan['planName'],
                    style: const TextStyle(
                      fontSize: 22, // 🔥 increased
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),


                  Text(
                    "₹${plan['billableAmount']}",
                    style: const TextStyle(
                      fontSize: 28, // 🔥 increased
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  Text(
                    "/ ${plan['planAmountPer']}",
                    style: const TextStyle(
                      fontSize: 14, // 🔥 increased
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ✨ FEATURES (FULL LIST - NO LIMIT)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (plan['planFeatures'] as List)
                        .map<Widget>(
                          (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            const Icon(Icons.check,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                f,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,// 🔥 increased
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 14),

                  // 🔘 BUTTON (bigger)
                  SizedBox(
                    width: double.infinity,
                    height: 42, // 🔥 increased
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFB8C00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {

                        final sub = await service.createSubscription(
                          token: token,
                          planId: plan['_id'],
                          userId: userId,
                        );

                        print("SUB RESPONSE => $sub");

                        if (sub == null) {
                          print("Subscription null");
                          return;
                        }

                        final subscription = sub['subscription'];

                        if (subscription == null) {
                          print("Subscription object missing");
                          return;
                        }

                        final orderId = subscription['id'];
                        final amount = subscription['amount'];
                        final keyId = subscription['key_id'];

                        print("ORDER ID => $orderId");
                        print("AMOUNT => $amount");
                        print("KEY ID => $keyId");

                        openPaymentGateway({
                          "orderId": orderId,
                          "amount": amount,
                          "key_id": keyId,
                        });
                      },
                      child: const Text(
                        "Buy Plan",
                        style: TextStyle(
                          fontSize: 15, // 🔥 increased
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
    );
  }
}