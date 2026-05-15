import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/story_model.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../Settings/until/PImages.dart';

class StorySingleWidgetUi extends StatelessWidget {
  final StoryModel story;
  const StorySingleWidgetUi({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // width: size.width * 0.26,
      height: size.height * 0.2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  context
                      .read<StoryViewModel>()
                      .updateStoryModel(story, context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    height: size.height * .19,
                    width: size.width * 0.26,
                    story.media?.first.content ?? '',
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      PImages.noImage,
                      height: size.height * .19,
                      width: size.width * 0.26,
                      fit: BoxFit.fill,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: textWidget(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    text: story.userName == null || story.userName!.isEmpty
                        ? ''
                        : story.userName,
                    color: Colors.white),
              )
            ],
          ),
          Positioned(
            top: (size.height * 0.19) - (46 / 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(story.userProfileImg ?? '',
                  height: 46.0,
                  width: 46.0,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                        PImages.profile,
                        height: 46.0,
                        width: 46.0,
                        fit: BoxFit.fill,
                      )),
            ),
          )
        ],
      ),
    );
  }
}
