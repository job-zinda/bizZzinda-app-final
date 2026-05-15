import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/conversation_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view_model/chat_details_view_model.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class ChatAppbarUi extends StatelessWidget {
  const ChatAppbarUi({super.key});

  @override
  Widget build(BuildContext context) {
    ChatDetailsViewModel chatDetailViewModel = context.read<ChatDetailsViewModel>();
    return Consumer<ChatDetailsViewModel>(
      builder: (context, value, child) => AppBar(
        automaticallyImplyLeading: false,
        title: value.pageType == "from profile"
            ? profileChat(context)
            : value.pageType == "lets plan"
                ? letsPlanAppbar(context)
                : chatappbar(context),
      ),
    );
  }

  Widget profileChat(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 10),
        Consumer<PostViewModel>(
          builder: (context, value, child) {
            final profileImage = value.otherUser?.profileImageUrl ?? '';
            return CircleAvatar(
              backgroundImage: profileImage.isEmpty
                  ? AssetImage(PImages.profile)
                  : safeImageProvider(profileImage, placeholderAsset: PImages.profile),
            );
          },
        ),
        const SizedBox(width: 10),
        Consumer<PostViewModel>(
          builder: (context, value, child) => textWidget(
            text: value.otherUser?.name ?? "Unknown",
            color:Color(0xFF8A4FFF),
          ),
        ),
      ],
    );
  }

  Widget letsPlanAppbar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.black,
          child: Image.asset(PImages.logo3),
        ),
        const SizedBox(width: 10),
        textWidget(
          text: "Job Zinda Admin",
          color: Color(0xFF8A4FFF),
        ),
      ],
    );
  }

  Widget chatappbar(BuildContext context) {
    final chatModel = context.read<ChatDetailsViewModel>().conversationModel;
    final participant = chatModel?.participants?.firstWhere(
          (p) => p.userId?.sId != LoggedInUser.id,
          orElse: () => Participants(),
        );

    final name = participant?.userId?.name ?? "Unknown";
    final profileImageUrl = participant?.userId?.profileImageUrl ?? "";

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            context
                .read<ChatViewModel>()
                .fetchAllConversations();
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundImage: profileImageUrl.isEmpty
              ? AssetImage(PImages.profile)
              : safeImageProvider(profileImageUrl, placeholderAsset: PImages.profile),
        ),
        const SizedBox(width: 10),
        textWidget(
          text: name,
          color: Color(0xFF8A4FFF),
        ),
      ],
    );
  }
}
