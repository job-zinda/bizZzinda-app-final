import 'package:flutter/material.dart';
import 'package:biz_zinda/view/chat_section/all_chat_widget/view/all_chat_section.dart';
import 'package:biz_zinda/view/chat_section/chat_pages/view/widgets/chat_filter.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:biz_zinda/view/chat_section/unread_chat_widget/view/unread_chat_section.dart';
import 'package:provider/provider.dart';

class PrimaryChatWidgetUi extends StatelessWidget {
  const PrimaryChatWidgetUi({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [const ChatFilterUi(), main()],
      ),
    );
  }

  Widget main() {
    return Selector<ChatViewModel, String>(
      selector: (p0, p1) => p1.allUnreadView,
      builder: (context, value, child) {
        switch (value) {
          case ChatViewStatus.all:
            return const AllChatSection();
          case ChatViewStatus.unread:
            return const UnreadChatSection();

          default:
            return const AllChatSection();
        }
      },
    );
  }
}
