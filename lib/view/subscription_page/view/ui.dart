import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/view/subscription_page/view/widgets/subscription_body.dart';
import 'package:biz_zinda/view/subscription_page/view/widgets/subscription_heading.dart';

class SubscriptionPageUi extends StatelessWidget {
  const SubscriptionPageUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Color(0xFFFB8C00),
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElavatedTextButton(
        bgcolor: PColors.white,
        borderRadius: 18,
        borderColor: Color(0xFFFB8C00),
        textColor:Color(0xFFFB8C00),
        text: "Lets go",
        onPressed: () {
          context.pushNamed(PPages.planListUi);
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  PImages.open_gift_box,
                  height: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                const SubscriptionHeading(),
                const SubscriptionBodyUi(),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
