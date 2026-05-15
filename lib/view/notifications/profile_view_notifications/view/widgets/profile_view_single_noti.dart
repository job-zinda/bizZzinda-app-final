import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/Settings/widgets/time_function.dart';
import 'package:biz_zinda/model/notification_model.dart';
import 'package:biz_zinda/model/post_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../../view_model/notification_view_model.dart';
import '../../../../../view_model/post_view_model.dart';
import '../../../../my_profile/view/wallet_screen.dart';
import '../../../../other_user_profile/view/other_user_profile_screen.dart';
import '../../../../plansforyou/PlanDetailsScreen.dart';
import '../../../../../Settings/until/PPages.dart';
import '../../../../task_corner_assignments.dart';
import '../../../notification_pages/view/widgets/icon_more_widget.dart';


class ProfileViewSingleNotiWidget extends StatelessWidget {
  final NotificationModel? notificationModel;

  const ProfileViewSingleNotiWidget({
    super.key,
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {

    String type = notificationModel?.notificationType ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFFB8C00),),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 9.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PROFILE IMAGE OR ICON
            InkWell(
              onTap: () {
                if (type != "task" && type != "wallet") {
                  if (notificationModel?.sender?.sId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUserProfileScreen(
                          userId: notificationModel?.sender?.sId ?? '',
                        ),
                      ),
                    );
                  }
                }
              },
              child: (type == "task" || type == "wallet")

              /// TASK / WALLET → ICON
                  ? CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFFB8C00),
                child: Icon(
                  type == "task"
                      ? Icons.task_alt
                      : Icons.account_balance_wallet,
                  color: const Color(0xFFFB8C00),
                  size: 26,
                ),
              )

              /// OTHER → PROFILE IMAGE
                  : CircleAvatar(
                radius: 30,
                backgroundImage:
                (notificationModel?.sender?.profileImageUrl ?? '')
                    .isEmpty
                    ? AssetImage(PImages.profile) as ImageProvider
                    : NetworkImage(
                  notificationModel?.sender?.profileImageUrl ??
                      '',
                ),
              ),
            ),

            const SizedBox(width: 13),

            /// NOTIFICATION TEXT
            Expanded(
              child: InkWell(
                onTap: () async {

                  context
                      .read<NotificationViewModel>()
                      .notificationRead(id: notificationModel?.sId ?? '');

                  /// PROFILE VIEW / FOLLOW
                  if (type == 'profile_view' || type == 'follow') {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherUserProfileScreen(
                          userId: notificationModel?.sender?.sId ?? '',
                        ),
                      ),
                    );
                  }

                  /// LIKE / COMMENT
                  else if (type == 'like' || type == 'comment') {

                    PostViewModel postViewModel =
                    context.read<PostViewModel>();

                    postViewModel.postDetails = PostModel(
                      sId: notificationModel?.connectedPostId?.sId,
                    );

                    EasyLoading.show();

                    await postViewModel.fetchPostDetails();

                    EasyLoading.dismiss();

                    context.pushNamed(PPages.profilePostDetailsUi);
                  }

                  /// TASK
                  else if (type == 'task') {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskCornerAssignmentsPage(),
                      ),
                    );
                  }

                  /// WALLET
                  else if (type == 'wallet') {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalletScreen(),
                      ),
                    );
                  }
                },

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 11),

                    /// DESCRIPTION
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFFFB8C00),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: notificationModel?.description ?? '',
                            style: const TextStyle(
                              color: Color(0xFFFB8C00),
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 10)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 7),

                    /// TIME
                    textWidget(
                      text: TimeAgoClass.getHoursAgo(
                          notificationModel?.sentOn ?? ''),
                      fontsize: 12,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// MORE ICON
            IconMoreWidget(
              notificationModel: notificationModel,
            ),
          ],
        ),
      ),
    );
  }
}