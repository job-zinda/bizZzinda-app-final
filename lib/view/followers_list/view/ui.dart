import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/view/followers_list/view/widgets/search_btn.dart';
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class FollowersScreen extends StatelessWidget {
  final String profileId;
  const FollowersScreen({Key? key, required this.profileId}) : super(key: key);

  // @override
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Followers')),
    //   body: Consumer<ProfileViewModel>(
    //     builder: (context, value, child) => SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           // Search Button
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: FollowerSearchButtonUi(
    //               profileId: profileId,
    //             ),
    //           ),
    //           PagedListView(
    //             pagingController: value.followersController,
    //             shrinkWrap: true,
    //             physics: NeverScrollableScrollPhysics(),
    //             builderDelegate: PagedChildBuilderDelegate<dynamic>(
    //                 noItemsFoundIndicatorBuilder: (context) =>  Container(
    //                   height: 500,
    //                       child: Center(child: Text('No Data found')),
    //                     ),
    //                 itemBuilder: (context, item, index) {
    //                   final follower = item;
    //                   return ListTile(
    //                     onTap: () async {
    //                       bool? status = await context
    //                           .read<PostViewModel>()
    //                           .fetchOtherUserProfileDetails(
    //                               userID: follower.followingDetails!.sId ?? "");
    //                       if (status!) {
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) =>
    //                                 const OtherUserProfileScreen(),
    //                           ),
    //                         );
    //                       }
    //                     },
    //                     leading: CircleAvatar(
    //                       backgroundImage: follower
    //                               .followingDetails!.profileImageUrl!.isEmpty
    //                           ? AssetImage(PImages.profile)
    //                           : NetworkImage(
    //                               follower.followingDetails!.profileImageUrl ??
    //                                   ""),
    //                     ),
    //                     title: Text(
    //                       follower.followingDetails!.name ?? "",
    //                       style: TextStyle(color: PColors.white),
    //                     ),
    //                     //  subtitle: Text(
    //                     //   follower.followingDetails!.pr ?? "",
    //                     //   style: TextStyle(color: PColors.white),
    //                     // ),
    //                   );
    //                 }),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(title: const Text('Followers')),
      body: Consumer<ProfileViewModel>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FollowerSearchButtonUi(
                  profileId: profileId,
                ),
              ),
              PagedListView(
                pagingController: value.followersController,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    noItemsFoundIndicatorBuilder: (context) => Container(
                          height: 500,
                          child: Center(child: Text('No Data found',style: TextStyle(color: Color(0xFFFB8C00),),)),
                        ),
                    itemBuilder: (context, item, index) {
                      final follower = item;
                      return ListTile(
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtherUserProfileScreen(
                                  userId: follower.followingDetails?.sId),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage: follower
                                  .followingDetails!.profileImageUrl!.isEmpty
                              ? AssetImage(PImages.profile)
                              : NetworkImage(
                                  follower.followingDetails!.profileImageUrl ??
                                      ""),
                        ),
                        title: Text(
                          follower.followingDetails!.name ?? "",
                          style: TextStyle(color: Color(0xFFFB8C00),),
                        ),
                        //  subtitle: Text(
                        //   follower.followingDetails!.pr ?? "",
                        //   style: TextStyle(color: PColors.white),
                        // ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
