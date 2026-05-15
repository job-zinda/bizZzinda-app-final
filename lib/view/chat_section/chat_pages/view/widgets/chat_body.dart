import 'package:flutter/material.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:biz_zinda/view/chat_section/chat_pages/view/widgets/lets_plan_chat_widget_ui.dart';
import 'package:biz_zinda/view/chat_section/chat_pages/view/widgets/primary_chat_widget_ui.dart';
import 'package:provider/provider.dart';

class ChatBodyUi extends StatelessWidget {
  const ChatBodyUi({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: main(),
          ),
        ],
      ),
    );
  }

  Widget main() {
    return Selector<ChatViewModel, String>(
      selector: (p0, p1) => p1.view,
      builder: (context, value, child) {
        switch (value) {
          case ChatViewStatus.primary:
            return ListView(
              children: const [PrimaryChatWidgetUi()],
            );
          case ChatViewStatus.letsPlan:
            return ListView(
              children: const [LetsPlanChatWidgetUi()],
            );
          default:
            return ListView(
              children: const [PrimaryChatWidgetUi()],
            );
        }
      },
    );
  }
}
