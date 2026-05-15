import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/view/chat_section/all_chat_widget/view/widgets/chat_card.dart';
import 'package:provider/provider.dart';

import '../../../../model/conversation_model.dart';
import '../../../../view_model/chat_view_model.dart';

class UnreadChatSection extends StatelessWidget {
  const UnreadChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    ChatViewModel chatViewModel = context.watch<ChatViewModel>();
    List<ConversationModel> conversationList = chatViewModel.conversationList
        .where((element) => (element.unreadCount ?? 0) > 0)
        .toList();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: conversationList.isEmpty
          ? SizedBox(
              height: 500,
              child: Center(
                child: Text(
                  "No data!!!",
                  style: TextStyle(color: Color(0xFFFB8C00),),
                ),
              ),
            )
          : ListView.builder(
              itemCount: conversationList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => ChatCard(
                conversationModel: conversationList[index],
              ),
            ),
    );
  }
}
