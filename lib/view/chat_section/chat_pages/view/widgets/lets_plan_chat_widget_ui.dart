import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/view_model/chat_badge_viewmodel.dart';
import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:provider/provider.dart';
class LetsPlanChatWidgetUi extends StatelessWidget {
  const LetsPlanChatWidgetUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [main(context)],
    );
  }

  Widget main(BuildContext context) {
    return ListTile(
      onTap: (){

         context
              .read<BadgeViewModel>()
              .updatemessage(context: context);
        context.read<ChatDetailsViewModel>().fetchAllQueryMessages();
        context.pushNamed(PPages.chatDetailsPageui);
      },
        title: Text(
          "Job Zinda Admin",
          style: TextStyle(color:  Color(0xFF8A4FFF),),
        ),
        leading: CircleAvatar(
          backgroundColor:  Color(0xFF8A4FFF),
          backgroundImage: AssetImage(
            PImages.logo3,
            
          ),
        ));
    // return Selector<ChatViewModel, String>(
    //   selector: (p0, p1) => p1.allUnreadView,
    //   builder: (context, value, child) {
    //     switch (value) {
    //       case ChatViewStatus.all:
    //         return AllChatSection();
    //       case ChatViewStatus.unread:
    //         return UnreadChatSection();

    //       default:
    //         return AllChatSection();
    //     }
    //   },
    // );
  }
}
