import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../services/wallet_service.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import '../../../model/wallet_transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biz_zinda/model/logged_in_user.dart';

import '../../../services/wallet_share_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScreenshotController _screenshotController =
  ScreenshotController();
  double walletBalance = 0;
  List<WalletTransaction> transactions = [];
  List<WalletTransaction> withdrawals = [];
  String upiId = '';
  String userId = '';
  bool loading = true;
  bool withdrawalLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // -------------------- Earnings --------------------
  double get dailyEarnings {
    final today = DateTime.now();
    return transactions
        .where((txn) =>
    txn.transactionType == 'credit' &&
        txn.createdAt.year == today.year &&
        txn.createdAt.month == today.month &&
        txn.createdAt.day == today.day)
        .fold(0, (sum, txn) => sum + txn.amount);
  }

  double get monthlyEarnings {
    final now = DateTime.now();
    return transactions
        .where((txn) =>
    txn.transactionType == 'credit' &&
        txn.createdAt.year == now.year &&
        txn.createdAt.month == now.month)
        .fold(0, (sum, txn) => sum + txn.amount);
  }

  // double get totalEarnings {
  //   return transactions
  //       .where((txn) => txn.transactionType == 'credit')
  //       .fold(0, (sum, txn) => sum + txn.amount);
  // }
  double get totalEarnings {
    double creditTotal = transactions
        .where((txn) => txn.transactionType == 'credit')
        .fold(0.0, (sum, txn) => sum + txn.amount);

    return walletBalance + creditTotal;
  }

  // -------------------- Analytics Item --------------------
  Widget _modernAnalyticsBox(String title, double amount) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- Share Earnings --------------------
  Future<void> _shareWalletWithScreenshot() async {
    try {
      // Small delay to make sure UI fully rendered
      await Future.delayed(const Duration(milliseconds: 200));

      final imageBytes = await _screenshotController.capture(
        pixelRatio: 2.5, // better quality
      );

      if (imageBytes == null) {
        debugPrint("Screenshot failed");
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/jobzinda_wallet.png');

      await file.writeAsBytes(imageBytes);

      final message = '''
This is my earnings from JobZinda 💚
Total Earned: ₹${totalEarnings.toStringAsFixed(0)}

Register using my referral code: ${LoggedInUser.referralCode ?? ""}

Let's grow together 🤝

Download the app 👇
https://play.google.com/store/apps/details?id=com.jobZinda.customers
''';

      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
        subject: 'Join JobZinda & Earn 💚',
      );
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  // -------------------- Init --------------------
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ?? LoggedInUser.id ?? '';
    await _fetchWallet();
  }

  // -------------------- Fetch Wallet --------------------
  Future<void> _fetchWallet() async {
    setState(() => loading = true);
    final ws = WalletService();

    walletBalance = await ws.getWalletBalance(userId);
    transactions = await ws.getWalletTransactions(userId, limit: 5);

    final allRequests = await ws.getWithdrawalRequests(userId);
    withdrawals =
        allRequests.where((t) => t.source == 'withdrawal').toList();

    // Remove duplicates based on 'id'
    final uniqueMap = {for (var txn in withdrawals) txn.id: txn};
    withdrawals = uniqueMap.values.toList();

    setState(() => loading = false);
  }

  bool get hasPendingWithdrawal =>
      withdrawals.any((txn) => txn.status == 'pending');

  // -------------------- Request Withdrawal --------------------
  Future<void> _requestWithdrawal() async {
    if (hasPendingWithdrawal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You already have a pending withdrawal request. Please wait until it is processed.',
          ),
        ),
      );
      return;
    }

    final ws = WalletService();
    TextEditingController upiController = TextEditingController(text: upiId);
    double amount = walletBalance;
    bool confirmed = false;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Withdrawal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your UPI ID to receive payment:'),
            TextField(
              controller: upiController,
              decoration: const InputDecoration(labelText: 'UPI ID'),
            ),
            const SizedBox(height: 12),
            Text('Amount: ₹${amount.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              confirmed = true;
              Navigator.pop(ctx);
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );

    if (confirmed && upiController.text.isNotEmpty) {
      setState(() => withdrawalLoading = true);
      try {
        bool ok =
        await ws.requestWithdrawal(userId, amount, upiController.text);
        if (ok) {
          upiId = upiController.text;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Withdrawal requested successfully.')),
          );
          await _fetchWallet();
        }
      } catch (e) {
        String message = e.toString().contains('pending withdrawal')
            ? 'You already have a pending withdrawal request.'
            : 'Failed to request withdrawal. Please try again later.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } finally {
        setState(() => withdrawalLoading = false);
      }
    }
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.toLocal();
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
  }

  // -------------------- Build UI --------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final isSmallDevice = width < 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(color: Color(0xFFFB8C00),),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 Screenshot Wrapped Wallet Card
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(width * 0.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFB8C00),
                        Color(0xFFFFE0B2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Balance Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: width * 0.07,
                            backgroundColor:
                            Colors.white.withOpacity(0.2),
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: width * 0.07,
                            ),
                          ),
                          SizedBox(width: width * 0.04),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Available Balance",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isSmallDevice ? 14 : 16,
                                ),
                              ),
                              SizedBox(height: height * 0.005),
                              Text(
                                "₹${walletBalance.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                  isSmallDevice ? 22 : 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: height * 0.03),

                      /// Earnings Row
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          _modernAnalyticsBox(
                              "Daily", dailyEarnings),
                          _modernAnalyticsBox(
                              "Monthly", monthlyEarnings),
                          _modernAnalyticsBox(
                              "Total", totalEarnings),
                        ],
                      ),

                      SizedBox(height: height * 0.03),

                      /// Buttons Row
                      Row(
                        children: [

                          /// Share Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed:
                              _shareWalletWithScreenshot,
                              icon: const Icon(Icons.share,
                                  size: 18),
                              label: const Text("Share"),
                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.white,
                                foregroundColor:
                                const Color(0xFFFB8C00),
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(16),
                                ),
                                padding:
                                EdgeInsets.symmetric(
                                  vertical:
                                  height * 0.018,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: width * 0.04),

                          /// Withdraw Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (walletBalance < 200) {
                                  ScaffoldMessenger.of(
                                      context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Minimum withdrawal amount is ₹200"),
                                    ),
                                  );
                                  return;
                                }

                                if (hasPendingWithdrawal) {
                                  ScaffoldMessenger.of(
                                      context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "You already have a pending withdrawal."),
                                    ),
                                  );
                                  return;
                                }

                                _requestWithdrawal();
                              },
                              icon: const Icon(Icons.upload,
                                  size: 18),
                              label:
                              const Text("Withdraw"),
                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.white
                                    .withOpacity(0.2),
                                foregroundColor:
                                Colors.white,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(16),
                                ),
                                padding:
                                EdgeInsets.symmetric(
                                  vertical:
                                  height * 0.018,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (hasPendingWithdrawal)
                        Padding(
                          padding:
                          EdgeInsets.only(
                              top: height * 0.015),
                          child: const Text(
                            "You already have a pending withdrawal request.",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: height * 0.04),

              /// Recent Transactions Title
              // -------------------- Recent Transactions --------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Recent Transactions',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.history, color: Colors.purple),
                ],
              ),
              const SizedBox(height: 8),
              if (transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No transactions found.',
                      style: TextStyle(color: Colors.grey)),
                ),
              ...transactions.map((txn) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: txn.transactionType == 'credit'
                        ? Colors.green[100]
                        : Colors.red[100],
                    child: Icon(
                      txn.transactionType == 'credit'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: txn.transactionType == 'credit'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  title: Text(
                    '₹${txn.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${txn.source}\n${txn.message}\n${_formatDateTime(txn.createdAt)}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    txn.status,
                    style: TextStyle(
                      color: txn.status == 'paid' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),),
              const SizedBox(height: 32),

              // -------------------- Withdrawals --------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Withdrawal Requests',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.account_balance, color: Colors.purple),
                ],
              ),
              const SizedBox(height: 8),
              if (withdrawals.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No withdrawal requests.',
                      style: TextStyle(color: Colors.grey)),
                ),
              ...withdrawals.map((txn) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[50],
                    child: const Icon(Icons.account_balance,
                        color: Colors.blue),
                  ),
                  title: Text(
                    'Withdrawal: ₹${txn.amount.toStringAsFixed(2)}',
                    style:
                    const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_formatDateTime(txn.createdAt)),
                  trailing: Text(
                    txn.status,
                    style: TextStyle(
                      color: txn.status == 'paid'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}