import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/time_function.dart';
import 'package:biz_zinda/model/comment_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/post_model.dart';
import 'package:biz_zinda/view/comment_pages/ui.dart';
import 'package:biz_zinda/view_model/comment_view_model.dart';
import 'package:biz_zinda/utils/guest_helper.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../../../Settings/widgets/text_widget.dart';
import '../../../../../Settings/widgets/verified_text.dart';
import '../../../../../view_model/post_view_model.dart';
import '../../../../other_user_profile/view/other_user_profile_screen.dart';
import '../../../../video_player/video_player.dart';
import 'home_bottom_sheet.dart';

class PostCard extends StatefulWidget {
  final PostModel? post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int likesCount = 0;
  @override
  void initState() {
    isLiked = widget.post?.isLiked ?? false;
    likesCount = widget.post?.likesCount ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl = widget.post?.user?.userProfilePicture;
    final mediaUrl = widget.post?.mediaUrl;

    return Column(
      children: [
        ListTile(
          onTap: () {
            if (widget.post?.user?.sId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OtherUserProfileScreen(userId: widget.post!.user!.sId),
                ),
              );
            }
          },
          contentPadding: EdgeInsets.zero,
          title: widget.post?.user == null
              ? const SizedBox()
              : VerifiedText(
                  text: widget.post?.user?.userName ?? '',
                  isVerified: widget.post?.user?.isVerified ?? false,
                  style: TextStyle(
                      color: Color(0xFF8A4FFF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
          subtitle: textWidget(
              text: widget.post?.user?.professionName ?? '',
              color: Colors.purple.shade200),
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: safeImageProvider(profileUrl, placeholderAsset: PImages.profile),
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Profile image load error: $exception');
            },
          ),
          trailing: widget.post?.user?.sId == null
              ? Container()
              : widget.post?.user?.sId == LoggedInUser.id
                  ? IconButton(
                      onPressed: () async {
                        await context.read<PostViewModel>().removePost(context, widget.post!.sId!);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Color(0xFF8A4FFF),
                        size: 18,
                      ))
                  : IconButton(
                      onPressed: () async {
                        await context
                            .read<PostViewModel>()
                            .fetchOtherUserProfileDetails(
                                userID: widget.post?.user?.sId ?? '');
                        await context
                            .read<PostViewModel>()
                            .updateBottomsheetoen(true);
                        showBottomSheet(
                          shape: const BeveledRectangleBorder(),
                          backgroundColor: PColors.black,
                          context: context,
                          builder: (context) =>
                              HomeBottomsheetUi(post: widget.post),
                        );
                      },
                      icon: Icon(
                        Icons.more_horiz,
                        color: Color(0xFF8A4FFF),
                      )),
        ),
        if (widget.post?.mediaType == "text")
          Container(
            alignment: Alignment.centerLeft,
            child: Text(widget.post!.bio!),
          ),
        if (widget.post?.mediaType == 'image' &&
            mediaUrl != null &&
            mediaUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: mediaUrl,
              fit: BoxFit.cover,
              memCacheWidth: 800,
              memCacheHeight: 800,
              placeholder: (context, url) => const SizedBox(height: 200),
              errorWidget: (context, url, error) => const SizedBox(),
            ),
          )
        else if (widget.post?.mediaType == 'video' &&
            mediaUrl != null &&
            mediaUrl.isNotEmpty)
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoViewScreen(
                            videoUrl: widget.post?.mediaUrl ?? '')));
              },
              child: Container(
                height: 300,
                width: double.infinity - 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.post!.thumbnail != null
                              ? widget.post!.thumbnail.toString()
                              : "",
                        ),
                        onError: (exception, stackTrace) {
                          // Avoid propagating the error to FlutterError.
                          debugPrint('Thumbnail load error: $exception');
                        })),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.play_circle,
                  color:Color(0xFF8A4FFF),
                  size: 50,
                ),
              )),
        const SizedBox(height: 4),
        actionWidget(widget.post, context),
        captionWidget(widget.post)
      ],
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
                if (isGuestUser(context)) return;
                context.read<PostViewModel>().postLike(postID: post?.sId ?? '');
                setState(() {
                  if (isLiked) {
                    likesCount = likesCount - 1;
                  } else {
                    likesCount = likesCount + 1;
                  }
                  isLiked = !isLiked;
                });
              },
              icon: isLiked == true
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : SvgPicture.asset(
                      PSvgs.heart,
               color:  Color(0xFF8A4FFF),
                      height: 24,
                    ),
            ),
            IconButton(
              onPressed: () {
                if (isGuestUser(context)) return;
                // CommentViewModel commentViewModel =
                //     context.read<CommentViewModel>();
                // commentViewModel.currentPage = 0;
                // commentViewModel.initCommentPagination(post!.sId.toString());
print("dfdjfdjf----${post!.sId}");
                context
                    .read<CommentViewModel>()
                    .updateIsReply(false, Comments());
                context
                    .read<CommentViewModel>()
                    .fetchComments(post!.sId.toString());
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: PColors.seed2,
                    builder: (ctx) => CommentsBottomSheet(post: widget.post));
              },
              icon: SvgPicture.asset(
                PSvgs.chat,
                color: Color(0xFF8A4FFF),
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
        Row(
          children: [
            textWidget(
                text: '$likesCount  like',
                color: Color(0xFF8A4FFF),
                fontsize: 12),
            const SizedBox(width: 6),
            textWidget(
                text: '${post?.commentsCount ?? ''} comments',
                color: Color(0xFF8A4FFF),
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
            style: TextStyle(color: Color(0xFF8A4FFF),),
            // delimiterStyle: TextStyle(color: PColors.seed,fontWeight: FontWeight.bold,),
            trimLines: 1,
            colorClickableText: Color(0xFF8A4FFF),
            trimCollapsedText: 'view more',
            trimExpandedText: 'show less',

            moreStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8A4FFF),
                height: 2),
          ),
          textWidget(
              text: TimeAgoClass.getHoursAgo(post?.createdAt ?? ''),
              // text: timeago.format(stringToDateTime(
              //         date: post?.createdAt ?? '',
              //         format: 'yyyy-MM-ddThh:mm:ss') ??
              //     DateTime.now()),
              color: Color(0xFF8A4FFF),
              fontsize: 11)
        ],
      ),
    );
  }
}
