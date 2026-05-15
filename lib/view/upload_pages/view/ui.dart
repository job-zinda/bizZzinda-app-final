import 'package:biz_zinda/view/Create_My_Offer/addofferscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:provider/provider.dart';

import '../../home_section/home_pages/view/widgets/add_story_screen.dart';

class UploadPagesUi extends StatelessWidget {
  const UploadPagesUi({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFFB8C00),
                      size: 20,
                    )),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                context.read<PostViewModel>().selectedUrl = null;
                context.read<PostViewModel>().selectedThumbanilFile = null;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  AddOfferScreen(),
                  ),
                );
              },
              leading: SvgPicture.asset(PSvgs.share_post,color: Color(0xFFFB8C00),),
              title: textWidget(text: 'Create My Offer', color: Color(0xFFFB8C00),),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                context.read<PostViewModel>().selectedUrl = null;
                context.read<PostViewModel>().selectedThumbanilFile = null;

                context.pushNamed(AddStoryScreen.route);
              },
              leading: SvgPicture.asset(
                PSvgs.share_story,
                color:Color(0xFFFB8C00),
              ),
              title: textWidget(
                text: 'Share My offer',
                color:Color(0xFFFB8C00),
              ),
            )
          ],
        ),
      ),
    );
  }
}
