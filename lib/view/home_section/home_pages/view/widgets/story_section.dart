import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/model/story_model.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/add_story_widget.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/story_single_widget.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:provider/provider.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});

  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StoryViewModel>().initStoryPagination();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    StoryViewModel storyViewModel = context.watch<StoryViewModel>();
    if (storyViewModel.storyController == null) {
      // Show a loading indicator or a placeholder while the controller is being initialized
      return SizedBox(
        height: size.height * 0.27,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return SizedBox(
      height: size.height * 0.27,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddstorywidgetUi(),
          Expanded(
            child: PagedListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                pagingController: storyViewModel.storyController!,
                builderDelegate: PagedChildBuilderDelegate<StoryModel>(
                  noItemsFoundIndicatorBuilder: (context) => const SizedBox(),
                  itemBuilder: (context, item, index) {
                    return StorySingleWidgetUi(story: item);
                  },
                )),
          ),
        ],
      ),
    );
  }
}
