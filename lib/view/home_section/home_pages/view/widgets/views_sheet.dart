import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:provider/provider.dart';

class StoryViewsSheetUi extends StatelessWidget {
  const StoryViewsSheetUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryViewModel>(
      builder: (context, value, child) => Container(
        height: 300,
        decoration: BoxDecoration(color: PColors.seed2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 4,
              ),
              title(),
              const SizedBox(
                height: 4,
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: value.storeyViews.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            value.storeyViews[index].user!.profileImageUrl ==
                                        null ||
                                    value.storeyViews[index].user!
                                        .profileImageUrl!.isEmpty
                                ? AssetImage(PImages.profile)
                                : NetworkImage(
                                    value.storeyViews[index].user!.profileImageUrl
                                        .toString(),
                                  ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      textWidget(
                          text: value.storeyViews[index].user!.name,
                          fontweight: FontWeight.bold,
                          color: PColors.white)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Consumer<StoryViewModel>(
      builder: (context, value, child) => Row(
        children: [
          SvgPicture.asset(PSvgs.eye),
          const SizedBox(
            width: 10,
          ),
          Text(
            "${value.storyCount.toString()} Views",
            style: TextStyle(color: PColors.white, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close))
        ],
      ),
    );
  }
}
