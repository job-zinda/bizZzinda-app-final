import 'package:biz_zinda/model/post_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


class HomeBottomsheetUi extends StatelessWidget {
  final PostModel? post;
  const HomeBottomsheetUi({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    await context.read<PostViewModel>().updateBottomsheetoen(false);
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, color: Colors.orange),
                ),
                const SizedBox(width: 10)
              ],
            ),
            Consumer<PostViewModel>(
              builder: (context, postViewModel, child) {
                return itemWidget(
                  icon: null,
                  title: postViewModel.isFollowed ? 'Unfollow' : 'Follow',
                  fun: () {
                    Navigator.pop(context);
                    if (postViewModel.isFollowed) {
                      postViewModel.unFollowUser(userID: post?.user?.sId ?? '');
                    } else {
                      postViewModel.followUser(userID: post?.user?.sId ?? '');
                    }
                  },
                );
              },
            ),
            Consumer<PostViewModel>(
              builder: (context, postViewModel, child) {
                return itemWidget(
                  icon: null,
                  title: 'Report',
                  fun: () async {
                    await postViewModel.reportProfile(
                      profileId: post!.user!.sId.toString(),
                      context: context,
                    );
                    await postViewModel.updateBottomsheetoen(false);
                  },
                );
              },
            ),
            itemWidget(
              icon: null,
              title: 'Cancel',
              fun: () async {
                await context.read<PostViewModel>().updateBottomsheetoen(false);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget itemWidget({String? icon, required String title, required Function()? fun}) {
    return ListTile(
      onTap: fun,
      leading: icon == null ? null : SvgPicture.asset(icon, height: 24),
      title: Text(title, style: TextStyle(color: title == 'Report' ? Colors.red : Colors.black)),
    );
  }
}