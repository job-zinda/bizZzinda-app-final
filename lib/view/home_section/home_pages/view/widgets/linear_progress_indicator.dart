import 'package:flutter/material.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:provider/provider.dart';

class LinearProgressIndicatorUi extends StatelessWidget {
  int currentPage;
  bool isVideoLoading;
  double progress;
  LinearProgressIndicatorUi({
    super.key,
    required this.currentPage,
    required this.isVideoLoading,
    required this.progress
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryViewModel>(
      builder: (context, value, child) =>
      value.isMyProfile? Row(
        children: value.myStoryModel.media!.asMap().entries.map((entry) {
          int index = entry.key;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: LinearProgressIndicator(
                value: index < currentPage
                    ? 1.0
                    : index == currentPage && !isVideoLoading
                        ? progress
                        : 0.0,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 5,
              ),
            ),
          );
        }).toList(),
      ):
      
      
       Row(
        children: value.storyModel.media!.asMap().entries.map((entry) {
          int index = entry.key;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: LinearProgressIndicator(
                value: index < currentPage
                    ? 1.0
                    : index == currentPage && !isVideoLoading
                        ? progress
                        : 0.0,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 5,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
