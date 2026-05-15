import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/main.dart';
import 'package:biz_zinda/model/banners_model.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/post_card.dart';
import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../model/post_model.dart';

class PostSection extends StatefulWidget {
  const PostSection({super.key});

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PostViewModel>().initPostPagination();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final postViewModel = context.watch<PostViewModel>();

    return PagedListView<int, dynamic>(

      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,

      pagingController: postViewModel.postController,

      builderDelegate: PagedChildBuilderDelegate<dynamic>(

        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 100),
            child: Text('No posts found'),
          ),
        ),

        itemBuilder: (context, item, index) {

          /// 🔵 BANNER
          if (item is Banners) {

            final bannerUrl =
            item.bannerImageUrl?.replaceAll("localhost", "10.0.2.2");

            if (bannerUrl == null || bannerUrl.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: GestureDetector(

                  onTap: () {

                    if (item.bannerOnTapAction?.toLowerCase() ==
                        "subscription") {

                      navigatorKey.currentContext!
                          .read<WrapperViewModel>()
                          .updatePageView(
                          WrapperViewStatus.normalProfile);

                    }

                  },

                  child: Image.network(
                    bannerUrl,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }

          /// 🟢 POST
          if (item is PostModel) {
            return PostCard(post: item);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}