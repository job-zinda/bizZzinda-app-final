import 'package:flutter/material.dart';
import 'package:biz_zinda/view/referal_page/widgets/referal_head.dart';
import 'package:biz_zinda/view/referal_page/widgets/referal_list.dart';

class ReferalPageUi extends StatelessWidget {
  const ReferalPageUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Referrals"),),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: const Column(
            children: [
              ReferalHeadUi(),
              SizedBox(
                height: 20,
              ),
              ReferredList()
            ],
          ),
        )
    );
  }
}