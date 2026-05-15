import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/Settings/widgets/verified_text.dart';
import 'package:biz_zinda/model/profile_model.dart';
import 'package:biz_zinda/view/search_section/view/widgets/search_image_widget_section.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

import '../../../other_user_profile/view/other_user_profile_screen.dart';

class SearchCard extends StatelessWidget {
  final ProfileModel profileModel;
  const SearchCard({super.key, required this.profileModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtherUserProfileScreen(userId: profileModel.sId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFFB8C00), // purple border
              width: 1.5,
            ),
            color: Colors.orange.shade50),

        child: Column(
          children: [
            SearchImageWidgetSectionUi(
              profileModel: profileModel,
            ),
            Column(
              children: [
                VerifiedText(
                  text: profileModel.name ?? '',
                  isVerified: profileModel.isVerified ?? false,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFB8C00),),
                  maxLines: 1,
                ),
                textWidget(
                    text: profileModel.profession ?? '',
                    fontsize: 12,
                    color: Color(0xFFFB8C00).withOpacity(0.6),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(
                  height: 10,
                ),
                //  textWidget(
                //     text: profileModel.bio ?? '',
                //     fontsize: 12,
                //     color: PColors.whiteOff.withOpacity(0.6),
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 1),
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    columnWidget(
                        title: 'Followers',
                        value: '${profileModel.followersCount ?? '0'}'),
                    // SizedBox(
                    //     height: 30,
                    //     child: VerticalDivider(
                    //       color: PColors.whiteOff.withOpacity(0.2),
                    //     )),
                    // columnWidget(
                    //     title: 'Projects',
                    //     value: '${profileModel.projectsCount ?? '0'}'),
                    SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          color: Color(0xFFFB8C00).withOpacity(0.2),
                        )),
                    columnWidget(
                        title: 'Feedback',
                        value: profileModel.rating?.toStringAsFixed(1) ?? '0'),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget columnWidget({required String title, required String value}) {
    return Flexible(
      child: Column(
        children: [
          textWidget(text: value, fontsize: 10, fontweight: FontWeight.w500),
          const SizedBox(
            height: 4,
          ),
          textWidget(
              text: title,
              fontsize: 8,
              color:Color(0xFFFB8C00).withOpacity(0.7),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ],
      ),
    );
  }
}
