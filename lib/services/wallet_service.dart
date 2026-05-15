import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/logged_in_user.dart';
import '../model/wallet_transaction_model.dart';
import '../utils/api_url.dart';


class WalletService {
  final String baseUrl;
  WalletService([String? baseUrl]) : baseUrl = baseUrl ?? AppUrl.baseurl;

  Future<double> getWalletBalance(String userId) async {
    // Prefer the dedicated profile details endpoint which returns the current user's data.
    final uri = Uri.parse('$baseUrl/api/v1/user/get-profile-details');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer ${LoggedInUser.accessToken}',
        'Content-Type': 'application/json',
      },
      body: json.encode({'userId': userId}),
    );

    print('[WalletService] get-profile-details response: ' + response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('[WalletService] parsed data: ' + data.toString());
      // Try both possible structures for walletBalance
      if (data['data'] != null && data['data']['walletBalance'] != null) {
        print('[WalletService] walletBalance: ${data['data']['walletBalance']}');
        return (data['data']['walletBalance'] ?? 0).toDouble();
      }
      if (data['data'] != null && data['data']['profileDetails'] != null && data['data']['profileDetails']['walletBalance'] != null) {
        print('[WalletService] walletBalance (profileDetails): ${data['data']['profileDetails']['walletBalance']}');
        return (data['data']['profileDetails']['walletBalance'] ?? 0).toDouble();
      }
      print('[WalletService] No walletBalance found in response');
      return 0;
    }

    // Fallback: try the old userId-based endpoint (in case backend version still expects it)
    // final fallbackUri = Uri.parse('$baseUrl/api/v1/user/get-user-profile?userId=$userId');
    // final fallbackResp = await http.get(fallbackUri);
    // if (fallbackResp.statusCode == 200) {
    //   final data = json.decode(fallbackResp.body);
    //   return (data['data']['walletBalance'] ?? 0).toDouble();
    // }

    throw Exception('Failed to load wallet balance');
  }

  Future<List<WalletTransaction>> getWalletTransactions(String userId, {int limit = 5}) async {
    final headers = {
      'Authorization': 'Bearer ${LoggedInUser.accessToken}',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/wallet/getWalletTransactions?userId=$userId&limit=$limit'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((e) => WalletTransaction.fromJson(e)).toList();
    }
    throw Exception('Failed to load transactions');
  }

  Future<List<WalletTransaction>> getWithdrawalRequests(String userId) async {
    final headers = {
      'Authorization': 'Bearer ${LoggedInUser.accessToken}',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/wallet/getWalletTransactions?userId=$userId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((e) => WalletTransaction.fromJson(e)).where((txn) => txn.source == 'withdrawal').toList();
    }
    throw Exception('Failed to load withdrawal requests');
  }

  Future<bool> requestWithdrawal(String userId, double amount, String upiId) async {
    final headers = {
      'Authorization': 'Bearer ${LoggedInUser.accessToken}',
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/wallet/requestWithdrawal'),
      headers: headers,
      body: json.encode({'userId': userId, 'amount': amount, 'upiId': upiId}),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Withdrawal request failed');
  }
}
