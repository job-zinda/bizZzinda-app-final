import 'package:share_plus/share_plus.dart';

class WalletShareService {
  static Future<void> shareWallet({
    required double totalEarnings,
    required String referralCode,
  }) async {
    final message = '''
This is my earnings from JobZinda 💚
Total Earned: ₹${totalEarnings.toStringAsFixed(0)}

Anyone can join and earn!
Register using my referral code: $referralCode

Let's grow together 🤝

Download the app 👇
https://play.google.com/store/apps/details?id=com.jobZinda.customers
''';

    await Share.share(
      message,
      subject: 'Join JobZinda & Earn 💚',
    );
  }
}