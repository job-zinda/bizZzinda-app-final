import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:badges/badges.dart' as badges;
import 'package:biz_zinda/view_model/chat_badge_viewmodel.dart';
import 'package:biz_zinda/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

class HomeAppbar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeAppbar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFB8C00),
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                child: const Icon(
                  Icons.menu,
                  weight: 10,
                  color: Colors.white,
                )),
            SizedBox(width: 10,),
            Image.asset(
              PImages.logo4,
              width: 120,
              fit: BoxFit.fitWidth,
              height: 80,
            ),
          ],
        ),
      ),
      actions: [
        Consumer<BadgeViewModel>(
          builder: (context, chatBadge, child) => GestureDetector(
            onTap: () {
              // context.read<BadgeViewModel>().clearLetsPlanBadge();
              context.read<ChatViewModel>().fetchAllConversations();

              // Navigator.pushNamed(context, PPages.subscriptionPageUi);
              context.read<ChatViewModel>().updateView(ChatViewStatus.letsPlan);
              context.pushNamed(PPages.chatPageUi);
            },
            child: chatBadge.adminMessageCount > 0
                ? badges.Badge(
              badgeStyle:
              badges.BadgeStyle(badgeColor: PColors.badgeColor),
              position: badges.BadgePosition.topEnd(top: -12, end: -4),
              badgeContent: const Text(''),
              child: SvgPicture.asset(PSvgs.lets_plan),
            )
                : SvgPicture.asset(PSvgs.lets_plan),
          ),
        ),

        const SizedBox(
          width: 16,
        ),
        Consumer<BadgeViewModel>(
          builder: (context, chatBadge, child) => GestureDetector(
            onTap: () {
              // context.read<BadgeViewModel>().clearMessageBadge();
              context.read<ChatViewModel>().fetchAllConversations();
              context.read<ChatViewModel>().updateView(ChatViewStatus.primary);

              context.pushNamed(PPages.chatPageUi);
            },
            child: chatBadge.userMessageCount > 0
                ? badges.Badge(
                    badgeStyle:
                        badges.BadgeStyle(badgeColor: PColors.badgeColor),
                    position: badges.BadgePosition.topEnd(top: -12, end: -4),
                    badgeContent: const Text(''),
                    child: SvgPicture.asset(PSvgs.message),
                  )
                : SvgPicture.asset(PSvgs.message),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Consumer<BadgeViewModel>(
          builder: (context, chatBadge, child) => GestureDetector(
            onTap: () {
              context.read<BadgeViewModel>().notificationRead();
              context.pushNamed(PPages.notificationsUi);
            },
            child: chatBadge.notificationCount > 0
                ? badges.Badge(
                    badgeStyle:
                        badges.BadgeStyle(badgeColor: PColors.badgeColor),
                    position: badges.BadgePosition.topEnd(top: -12, end: -4),
                    badgeContent: const Text(''),
                    child: SvgPicture.asset(PSvgs.notification),
                  )
                : SvgPicture.asset(PSvgs.notification),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
