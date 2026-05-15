import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/view/chat_section/all_chat_widget/view/widgets/chat_card.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../model/conversation_model.dart';

class AllChatSection extends StatelessWidget {
  const AllChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    ChatViewModel chatViewModel = context.watch<ChatViewModel>();
    List<ConversationModel> conversationList = chatViewModel.conversationList;
    return Container(
      height: MediaQuery.of(context).size.height - 200, // Adjust height to leave space for header/filter
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: conversationList.isEmpty
          ? Center(
              child: Text(
                "No data!!!",
                style: TextStyle(color: Color(0xFFFB8C00),),
              ),
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: conversationList.length,
              itemBuilder: (context, index) => ChatCard(
                conversationModel: conversationList[index],
              ),
            ),
    );
  }
}
