import 'package:flutter/material.dart';
import 'package:biz_zinda/main.dart';
import 'package:biz_zinda/model/chat_message_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view/chat_details_page/view/widgets/chat_appbar.dart';
import 'package:biz_zinda/view/chat_details_page/view/widgets/chat_bottom_bar.dart';
import 'package:biz_zinda/view/chat_details_page/view/widgets/my_chat_widget.dart';
import 'package:biz_zinda/view/chat_details_page/view/widgets/other_user_chat_widget.dart';
import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatDetailsPageui extends StatelessWidget {
  const ChatDetailsPageui({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatDetailsViewModel>(builder: (context, value, child) {
     
      return WillPopScope(
        onWillPop: () async{
            navigatorKey.currentContext!
                .read<ChatViewModel>()
                .fetchAllConversations();
                return true;
        },
        child: Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(80), child: ChatAppbarUi()),
          bottomNavigationBar: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const ChatBottomBarUi(),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: chatList(context),
          ),
        ),
      );
    });
  }

  Widget chatList(BuildContext context) {
    ChatDetailsViewModel chatDetailViewModel =
        context.watch<ChatDetailsViewModel>();
    List<ChatMessageModel> messages = chatDetailViewModel.messages;


    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Consumer<ChatDetailsViewModel>(
        builder: (context, value, child) =>
        value.loading?const Center(child: CircularProgressIndicator()):

         ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (LoggedInUser.id != messages[index].senderId!.sId) {
                return OtherUserChatWidget(
                  message: messages[index],
                );
              } else {
                return MyChatWidget(
                  message: messages[index],
                );
              }
            }),
      ),
    );
 
  }
}
