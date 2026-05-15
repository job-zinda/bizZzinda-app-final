import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_zinda/model/post_model.dart';
import 'package:biz_zinda/view/my_profile/view/widgets/single_gallery_widget.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/post_view_model.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  @override
  void initState() {
    PostViewModel postViewModel = context.read<PostViewModel>();
    postViewModel.currentPageOtherUserPost = 0;
    postViewModel.initOtherUserPostPagination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = context.watch<PostViewModel>();
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: PagedGridView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            pagingController: postViewModel.otherUserPostController,
            builderDelegate: PagedChildBuilderDelegate<PostModel>(
              
              noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Text('No posts found',style: TextStyle(color: Color(0xFFFB8C00),),),
              )),
              itemBuilder: (context, item, index) {
                return SingleGalleryWidget(postModel: item);
              },
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                crossAxisCount: 3,
                childAspectRatio: .8)));
  }
}
