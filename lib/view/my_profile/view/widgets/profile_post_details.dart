import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/Settings/widgets/time_function.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/post_model.dart';
import 'package:biz_zinda/view/comment_pages/ui.dart';
import 'package:biz_zinda/view/video_player/video_player.dart';
import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:biz_zinda/view_model/comment_view_model.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ProfilePostDetailsUi extends StatelessWidget {
  const ProfilePostDetailsUi({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(),
    body: Consumer<PostViewModel>(
      builder: (context, value, child) {
        final postDetails = value.postDetails;

        if (postDetails == null) {
          return Center(child: Text("No post details available"));
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 17),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (postDetails.user?.sId == LoggedInUser.id)
                      IconButton(
                        onPressed: () async {
                          await context.read<PostViewModel>().removePost(
                              context, postDetails.sId.toString());
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: PColors.white,
                          size: 18,
                        ),
                      )
                  ],
                ),
                if (postDetails.mediaType == "text")
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(postDetails.bio.toString()),
                  ),
                if (postDetails.mediaType == 'image')
            
                
                  AspectRatio(
                    aspectRatio:.7,
                    child: Image.network(
                      postDetails.mediaUrl ?? '',
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(PImages.noImage),
                    ),
                  ),
                if (postDetails.mediaType == 'video')

                 
                  InkWell(
                    onTap: () {
                      context.read<PostViewModel>().fetchPostDetails();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoViewScreen(
                            videoUrl: postDetails.mediaUrl ?? '',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            postDetails.thumbnail.toString(),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                actionWidget(postDetails, context),
                captionWidget(postDetails),
              ],
            ),
          ),
        );
      },
    ),
  );
}


  Widget actionWidget(PostModel? post, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<PostViewModel>().postLike(postID: post.sId ?? '');
                // setState(() {
                //   if (isLiked) {
                //     likesCount = likesCount - 1;
                //   } else {
                //     likesCount = likesCount + 1;
                //   }
                //   isLiked = !isLiked;
                // });
              },
              icon: post!.isLiked == true
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : SvgPicture.asset(
                      PSvgs.heart,
                      height: 24,
                    ),
            ),
            IconButton(
              onPressed: () {
                //      CommentViewModel commentViewModel =
                //     context.read<CommentViewModel>();
                // commentViewModel.currentPage = 0;
                // commentViewModel.initCommentPagination(post!.sId.toString());
                context
                    .read<CommentViewModel>()
                    .fetchComments(post.sId.toString());
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: PColors.seed2,
                    builder: (ctx) => CommentsBottomSheet(post: post));
              },
              icon: SvgPicture.asset(
                PSvgs.chat,
                height: 24,
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: SvgPicture.asset(
            //     PSvgs.share,
            //     height: 24,
            //   ),
            // ),
          ],
        ),
        post.likesCount == null
            ? Container()
            : Row(
                children: [
                  textWidget(
                      text: '${post.likesCount}  like',
                      color: PColors.whiteOff.withOpacity(0.6),
                      fontsize: 12),
                  const SizedBox(width: 6),
                  textWidget(
                      text: '${post.commentsCount ?? ''} comments',
                      color: PColors.whiteOff.withOpacity(0.6),
                      fontsize: 12),
                ],
              )
      ],
    );
  }

  Widget captionWidget(PostModel? post) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            post?.bio ?? '',
            trimMode: TrimMode.Line,
            style: TextStyle(color: PColors.whiteOff),
            // delimiterStyle: TextStyle(color: PColors.seed,fontWeight: FontWeight.bold,),
            trimLines: 1,
            colorClickableText: PColors.whiteOff.withOpacity(0.5),
            trimCollapsedText: 'view more',
            trimExpandedText: 'show less',

            moreStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: PColors.whiteOff.withOpacity(0.5),
                height: 2),
          ),
          post?.createdAt == null
              ? Container()
              : textWidget(
                  text: TimeAgoClass.getHoursAgo(post?.createdAt ?? ''),
                  // text: timeago.format(stringToDateTime(
                  //         date: post?.createdAt ?? '',
                  //         format: 'yyyy-MM-ddThh:mm:ss') ??
                  //     DateTime.now()),
                  color: PColors.whiteOff.withOpacity(0.5),
                  fontsize: 11)
        ],
      ),
    );
  }
}
