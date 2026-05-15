import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view/chat_section/chat_pages/view/widgets/chat_body.dart';
import 'package:biz_zinda/view/chat_section/chat_pages/view/widgets/chat_head.dart';

class ChatPageUi extends StatelessWidget {
  const ChatPageUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWidget(text: "Chat"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
          child: const Column(
            children: [
              ChatHeadUi(),
              // SizedBox(
              //   height: 30,
              // ),
              ChatBodyUi()
            ],
          ),
        ),
      ),
    );
  }
}
