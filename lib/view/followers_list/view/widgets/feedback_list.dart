import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/feedback_model.dart';
import 'package:biz_zinda/view/followers_list/view/widgets/search_btn.dart';
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class FeedbackListUI extends StatelessWidget {
  final String profileId;
  const FeedbackListUI({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedbacks')),
      body: Consumer<ProfileViewModel>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
            children: [
              PagedListView(
                pagingController: value.feedbackController,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    noItemsFoundIndicatorBuilder: (context) => Container(
                          height: 600,
                          child: Center(child: Text('No Data found')),
                        ),
                    itemBuilder: (context, item, index) {
                      FeedBacks feedBack = item;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtherUserProfileScreen(userId: feedBack.rater?.sId),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: PColors.seed2),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundImage: feedBack
                                                .rater!.profileImageUrl!.isEmpty
                                            ? AssetImage(PImages.profile)
                                            : NetworkImage(feedBack
                                                    .rater!.profileImageUrl ??
                                                ""),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            textWidget(
                                                text: feedBack.rater!.name!
                                                        .toUpperCase() ??
                                                    "",
                                                fontweight: FontWeight.bold,
                                                color: PColors.white),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 15,
                                                ),
                                                textWidget(
                                                    text:
                                                        " (${feedBack.rating.toString()})")
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  contentWidget(feedBack.review.toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget contentWidget(String text) {
    return ReadMoreText(
      text,
      trimMode: TrimMode.Line,
      style: TextStyle(color: PColors.whiteOff),
      // delimiterStyle: TextStyle(color: PColors.seed,fontWeight: FontWeight.bold,),
      trimLines: 2,
      colorClickableText: PColors.yellow,
      trimCollapsedText: 'Read more',
      trimExpandedText: 'Show less',
      lessStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: PColors.yellow,
          height: 1.2),
      moreStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: PColors.yellow,
          height: 1.2),
    );
  }
}
