// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:jora_customer/Settings/until/PImages.dart';
// import 'package:jora_customer/Settings/until/PSvgs.dart';
// import 'package:jora_customer/Settings/widgets/text_widget.dart';
// import 'package:jora_customer/model/comment_model.dart';
// import 'package:jora_customer/model/logged_in_user.dart';
// import 'package:jora_customer/view_model/comment_view_model.dart';
// import 'package:provider/provider.dart';

// class CommentCard extends StatelessWidget {
//   final bool showReply;
//   Comments comment;
//   String postId;
//   CommentCard(
//       {super.key,
//       required this.showReply,
//       required this.comment,
//       required this.postId});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, right: 5, bottom: 20),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 26,
//                 backgroundImage: comment.commentedBy!.profileImageUrl!.isEmpty
//                     ? AssetImage(PImages.profile)
//                     : NetworkImage(
//                         comment.commentedBy!.profileImageUrl.toString()),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                       text: TextSpan(
//                           text: comment.commentedBy!.name.toString(),
//                           style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xffE6E6E6)),
//                           children: [
//                         TextSpan(
//                           text: 'commented : ${comment.comment.toString()}',
//                           style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: Color(0xffE6E6E6)),
//                         )
//                       ])),
//                   const SizedBox(
//                     height: 6,
//                   ),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       textWidget(
//                           text: context
//                               .read<CommentViewModel>()
//                               .getRelativeTime(comment.createdAt.toString()),
//                           // text: timeago.format(stringToDateTime(
//                           //         date: comment?.createdAt ?? '',
//                           //         format: 'yyyy-MM-ddThh:mm:ss') ??
//                           //     DateTime.now()),
//                           fontsize: 10,
//                           color: const Color(0xff6A6A6A),
//                           fontweight: FontWeight.w300),
//                       const SizedBox(width: 8),
//                       // SvgPicture.asset(
//                       //   PSvgs.smallHeart,
//                       //   colorFilter: const ColorFilter.mode(
//                       //       Color(0xff6A6A6A), BlendMode.srcIn),
//                       //   height: 10,
//                       //   width: 10,
//                       // ),
//                       // const SizedBox(width: 8),
//                       // textWidget(
//                       //     text: 'Like',
//                       //     fontsize: 10,
//                       //     color: const Color(0xff6A6A6A),
//                       //     fontweight: FontWeight.w300),
//                       // const SizedBox(width: 8),
//                       SvgPicture.asset(
//                         PSvgs.reply,
//                         colorFilter: const ColorFilter.mode(
//                             Color(0xff6A6A6A), BlendMode.srcIn),
//                         height: 10,
//                         width: 10,
//                       ),
//                       const SizedBox(width: 8),
//                       GestureDetector(
//                         onTap: () {
//                           context
//                               .read<CommentViewModel>()
//                               .updateIsReply(true, comment);
//                           context
//                               .read<CommentViewModel>()
//                               .focusNode
//                               .requestFocus();
//                         },
//                         child: textWidget(
//                             text: 'Reply',
//                             fontsize: 10,
//                             color: const Color(0xff6A6A6A),
//                             fontweight: FontWeight.w300),
//                       ),

//                       GestureDetector(
//                         onTap: (){},
//                         child: Text("View Replys"))
//                     ],
//                   )
//                 ],
//               )),
//               const SizedBox(width: 10),
//               LoggedInUser.id == comment.commentedBy!.sId
//                   ? IconButton(
//                       onPressed: () {
//                         context
//                             .read<CommentViewModel>()
//                             .removeComment(comment.sId.toString(), postId);
//                       },
//                       icon: SvgPicture.asset(
//                         PSvgs.delete_comment,
//                       ))
//                   : Container()
//             ],
//           ),

//           //   const SizedBox(height: 20),
//           //   Row(
//           //     crossAxisAlignment: CrossAxisAlignment.center,
//           //     children: [
//           //       const SizedBox(width: 50),
//           //       CircleAvatar(
//           //         radius: 26,
//           //         child: Image.asset(
//           //           PImages.profile_pic,
//           //           fit: BoxFit.cover,
//           //         ),
//           //       ),
//           //       const SizedBox(width: 8),
//           //       Expanded(
//           //           child: Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         children: [
//           //           RichText(
//           //               text: const TextSpan(
//           //                   text: 'James mathew ',
//           //                   style: TextStyle(
//           //                       fontSize: 12,
//           //                       fontWeight: FontWeight.w700,
//           //                       color: Color(0xffE6E6E6)),
//           //                   children: [
//           //                 TextSpan(
//           //                   text: 'commented : Nice',
//           //                   style: TextStyle(
//           //                       fontSize: 12,
//           //                       fontWeight: FontWeight.w400,
//           //                       color: Color(0xffE6E6E6)),
//           //                 )
//           //               ])),
//           //           const SizedBox(
//           //             height: 6,
//           //           ),
//           //           Row(
//           //             crossAxisAlignment: CrossAxisAlignment.center,
//           //             children: [
//           //               textWidget(
//           //                   text: timeago.format(stringToDateTime(
//           //                           date: comment?.createdAt ?? '',
//           //                           format: 'yyyy-MM-ddThh:mm:ss') ??
//           //                       DateTime.now()),
//           //                   fontsize: 10,
//           //                   color: const Color(0xff6A6A6A),
//           //                   fontweight: FontWeight.w300),
//           //               const SizedBox(width: 8),
//           //               SvgPicture.asset(
//           //                 PSvgs.smallHeart,
//           //                 colorFilter: const ColorFilter.mode(
//           //                     Color(0xff6A6A6A), BlendMode.srcIn),
//           //                 height: 10,
//           //                 width: 10,
//           //               ),
//           //               const SizedBox(width: 8),
//           //               textWidget(
//           //                   text: 'Like',
//           //                   fontsize: 10,
//           //                   color: const Color(0xff6A6A6A),
//           //                   fontweight: FontWeight.w300),
//           //               const SizedBox(width: 8),
//           //               SvgPicture.asset(
//           //                 PSvgs.reply,
//           //                 colorFilter: const ColorFilter.mode(
//           //                     Color(0xff6A6A6A), BlendMode.srcIn),
//           //                 height: 10,
//           //                 width: 10,
//           //               ),
//           //               const SizedBox(width: 8),
//           //               textWidget(
//           //                   text: 'Reply',
//           //                   fontsize: 10,
//           //                   color: const Color(0xff6A6A6A),
//           //                   fontweight: FontWeight.w300),
//           //             ],
//           //           )
//           //         ],
//           //       )),
//           //       const SizedBox(width: 10),
//           //       IconButton(
//           //           onPressed: () {
//           //             context
//           //                 .read<CommentViewModel>()
//           //                 .removeComment(comment.sId.toString(), postId);
//           //           },
//           //           icon: SvgPicture.asset(
//           //             PSvgs.delete_comment,
//           //           ))
//           //     ],
//           //   ),
//           // ]
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/comment_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/post_model.dart';
import 'package:biz_zinda/model/reply_model.dart';
import 'package:biz_zinda/view/comment_pages/widgets/reply_card.dart';
import 'package:biz_zinda/view_model/comment_view_model.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final bool showReply;
  final Comments comment;
  final PostModel post;

  const CommentCard({
    super.key,
    required this.showReply,
    required this.comment,
    required this.post,
  });

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool showReplies = false; // Track if replies are visible
  List<Replies>? replies = []; // List of fetched replies

  void toggleReplies(BuildContext context) async {
    if (!showReplies) {
      // Fetch replies only when they are not already visible
      replies = await context
          .read<CommentViewModel>()
          .fetchReplies(widget.comment.sId.toString());
    }
    setState(() {
      showReplies = !showReplies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 5, bottom: 20),
      // child: Container(child: Text(widget.comment.commentedBy!.name.toString()),),
      child: widget.comment.commentedBy == null
          ? Container()
          : Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          widget.comment.commentedBy!.profileImageUrl!.isEmpty
                              ? AssetImage(PImages.profile) as ImageProvider
                              : NetworkImage(widget
                                  .comment.commentedBy!.profileImageUrl
                                  .toString()),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: widget.comment.commentedBy!.name.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffE6E6E6),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      ' commented: ${widget.comment.comment.toString()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffE6E6E6),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              textWidget(
                                text: context
                                    .read<CommentViewModel>()
                                    .getRelativeTime(
                                        widget.comment.createdAt.toString()),
                                fontsize: 10,
                                color: const Color(0xff6A6A6A),
                                fontweight: FontWeight.w300,
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                PSvgs.reply,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xff6A6A6A),
                                  BlendMode.srcIn,
                                ),
                                height: 10,
                                width: 10,
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  context.read<CommentViewModel>().setReplyTo(
                                      widget.comment.commentedBy!.name!);
                                  context
                                      .read<CommentViewModel>()
                                      .updateIsReply(true, widget.comment);
                                  // context.read<CommentViewModel>().focusNode.requestFocus();
                                },
                                child: textWidget(
                                  text: 'Reply',
                                  fontsize: 10,
                                  color: const Color(0xff6A6A6A),
                                  fontweight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => toggleReplies(context),
                                child: textWidget(
                                  text: showReplies
                                      ? 'Hide Replies'
                                      : 'View Replies',
                                  fontsize: 10,
                                  color: const Color(0xff6A6A6A),
                                  fontweight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    LoggedInUser.id == widget.comment.commentedBy!.sId || LoggedInUser.id==  widget.post.user!.sId!?

                    IconButton(
                      onPressed: () {
                        context.read<CommentViewModel>().removeComment(
                            widget.comment.sId.toString(), widget.post.sId!);
                      },
                      icon: SvgPicture.asset(
                        PSvgs.delete_comment,
                      ),
                    )
                    : Container(),
                  ],
                ),
                if (showReplies && replies != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 10),
                    child: Column(
                      children: replies!.map((reply) {
                        return ReplyCard(
                          reply: reply,
                          showReply: false,
                          commentId: widget.comment.sId.toString(),
                        );
                        // return CommentCard(
                        //   showReply: false,
                        //   comment: reply,
                        //   postId: widget.postId,
                        // );
                      }).toList(),
                    ),
                  ),
              ],
            ),
    );
  }
}
