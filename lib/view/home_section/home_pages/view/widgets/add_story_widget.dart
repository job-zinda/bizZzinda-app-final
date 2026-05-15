import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view/home_section/home_pages/view/widgets/add_story_screen.dart';
import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:biz_zinda/view_model/story_view_model.dart';
import 'package:provider/provider.dart';

class AddstorywidgetUi extends StatelessWidget {
  const AddstorywidgetUi({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      // width: size.width * 0.26,
      // height: size.height * 0.2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                  height: size.height * .19,
                  width: size.width * 0.26,
                  margin: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: PColors.black2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {

                       final profileVM = context.read<ProfileViewModel>();
                       final profileType = profileVM.profileModel?.accountType?.toLowerCase();
                       if (profileType == null) {
                         // Profile not yet loaded; show a snackbar.
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Please wait, profile loading…')),
                         );
                       } else if (profileType.isEmpty || profileType == "normal") {
                         // Normal users are routed to upgrade screen
                         context
                             .read<WrapperViewModel>()
                             .updatePageView(WrapperViewStatus.normalProfile);
                       } else {
                         // Freelancer or premium can add story
                         final storyVM = context.read<StoryViewModel>();
                         storyVM.selectedUrl = null;
                         context.pushNamed(AddStoryScreen.route);
                       }
                     
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: SvgPicture.asset(
                            PSvgs.add_status,
                            height: 40,
                          )),
                          const SizedBox(
                            height: 5,
                          ),
                          textWidget(
                              text: 'Add Story',
                              color: PColors.whiteOff.withOpacity(0.4),
                              fontsize: 12),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 35),
              Expanded(
                child: textWidget(
                  // text: 'sdbsd sd sd s dbs bs bd b',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: 'You',
                ),
              )
            ],
          ),
          Positioned(
            top: (size.height * 0.19) - (46 / 2),
            child: GestureDetector(
              onTap: () {
                context.read<StoryViewModel>().fetchMyStory(context);
              },
              child: Container(
                height: 46.0,
                width: 46.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: (LoggedInUser.profilePic?.isNotEmpty ?? false)
                            ? NetworkImage(LoggedInUser.profilePic!)
                            : AssetImage(PImages.profile),
                        fit: BoxFit.cover)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
