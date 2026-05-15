import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/model/reply_model.dart';
import 'package:biz_zinda/view_model/comment_view_model.dart';
import 'package:provider/provider.dart';

class ReplyCard extends StatefulWidget {
  final bool showReply;
  final String commentId;

  final Replies reply;


  const ReplyCard({
    super.key,
    required this.showReply,
    required this.reply,
    required this.commentId
  });

  @override
  _ReplyCardState createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 5, bottom: 20),
      child: widget.reply.repliedBy == null
          ? Container()
          :Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: widget.reply.repliedBy!.profileImageUrl!.isEmpty
                    ? AssetImage(PImages.profile) as ImageProvider
                    : NetworkImage(widget.reply.repliedBy!.profileImageUrl.toString()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: widget.reply.repliedBy!.name.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffE6E6E6),
                        ),
                        children: [
                          TextSpan(
                            text: ' commented: ${widget.reply.reply.toString()}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffE6E6E6),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    GestureDetector(
                      onTap: (){
                            context
                            .read<CommentViewModel>()
                            .removeReply(widget.reply.sId.toString(), widget.commentId);
                      },
                      child: Text("Remove",style: TextStyle(fontSize: 11,color: Colors.red),)),
                 
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // LoggedInUser.id == widget.comment.commentedBy!.sId
              //     ? IconButton(
              //         onPressed: () {
              //           context
              //               .read<CommentViewModel>()
              //               .removeComment(widget.comment.sId.toString(), widget.postId);
              //         },
              //         icon: SvgPicture.asset(
              //           PSvgs.delete_comment,
              //         ),
              //       )
              //     : Container(),
            ],
          ),
          
        ],
      ),
    );
  }
}
