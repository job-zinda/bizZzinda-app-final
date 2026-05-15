import 'package:flutter/material.dart';

class DrawerWalletButton extends StatelessWidget {
  final VoidCallback onTap;
  const DrawerWalletButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_balance_wallet, color: Colors.green),
      title: Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
