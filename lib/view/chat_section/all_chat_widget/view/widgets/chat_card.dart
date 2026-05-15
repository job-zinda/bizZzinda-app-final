import 'package:flutter/material.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/conversation_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view_model/chat_badge_viewmodel.dart';
import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:provider/provider.dart';

class ChatCard extends StatelessWidget {
  final ConversationModel conversationModel;

  const ChatCard({super.key, required this.conversationModel});

  @override
  Widget build(BuildContext context) {
    Participants participant = Participants();

    if (conversationModel.participants != null ||
        conversationModel.participants!.isEmpty) {
      participant = conversationModel.participants!.firstWhere(
        (participant) => participant.userId == null
            ? false
            : participant.userId!.sId != LoggedInUser.id,
        orElse: () => Participants(),
      );
      print("partt-----$participant");
    }

    if (participant.sId == null) {
      return Container();
    }

    final name = participant.userId?.name ?? "";

    final profileImageUrl = participant.userId?.profileImageUrl ?? "";

    return GestureDetector(
      onTap: () {
        if (conversationModel.unreadCount != 0) {
          context
              .read<ChatDetailsViewModel>()
              .updateConversationModel(conversationModel);
          // context.read<BadgeViewModel>().updatemessage(context: context);
          context.read<ChatDetailsViewModel>().updatemessage(
              lastMessageId:
                  conversationModel.lastMessage!.messageId!.sId.toString(),
              context: context);

          context.pushNamed(PPages.chatDetailsPageui);
        } else {
          context
              .read<ChatDetailsViewModel>()
              .updateConversationModel(conversationModel);
          context.read<ChatDetailsViewModel>().fetchAllConversations(1);
          context.pushNamed(PPages.chatDetailsPageui);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: profileImageUrl == null || profileImageUrl!.isEmpty
                       ? AssetImage(PImages.profile)
                       : safeImageProvider(profileImageUrl, placeholderAsset: PImages.profile),
                )
              ],
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textWidget(
                          text: name ?? "",
                          // text: conversationModel
                          //         .participants?.first.userId?.name ??
                          //     '',
                          fontweight: FontWeight.w500),
                      textWidget(
                          text: conversationModel.lastMessage != null
                              ? convertTo12HourTime(conversationModel
                                  .lastMessage!.messageId!.createdAt
                                  .toString())
                              : "",
                          color: Color(0xFF8A4FFF),
                          fontsize: 11)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: textWidget(
                              text:
                                  conversationModel.lastMessage?.content ?? '',
                              color: Color(0xFF8A4FFF),
                              fontsize: 12,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2)),
                      const SizedBox(
                        width: 7,
                      ),
                      conversationModel.unreadCount == 0
                          ? const Icon(
                              Icons.done,
                              size: 14,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: PColors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2),
                                child: textWidget(
                                    text:
                                        '${conversationModel.unreadCount ?? 0}',
                                    color: PColors.black,
                                    fontsize: 12,
                                    fontweight: FontWeight.w500),
                              ),
                            )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color(0xFF8A4FFF),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String convertTo12HourTime(String isoDate) {
    DateTime dateTime =
        DateTime.parse(isoDate).toLocal(); // Convert to local time
    return DateFormat('hh:mm a')
        .format(dateTime); // Format in 12-hour time with AM/PM
  }
}
