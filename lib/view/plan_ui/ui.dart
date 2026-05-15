import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view/plan_ui/widgets/plan_list.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class PlanUi extends StatelessWidget {
  const PlanUi({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // context
        //     .read<WrapperViewModel>()
        //     .updatePageView(WrapperViewStatus.profile);
        return false;
      },
      child: Scaffold(
        backgroundColor: PColors.black2,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: CustomElavatedTextButton(
        //   bgcolor: PColors.white,
        //   textColor: PColors.black,
        //   borderRadius: 0,
        //   text: "Lets go",
        //   onPressed: () {
        //     Navigator.pushNamed(context, PPages.editProfileUi);
        //   },
        // ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              context
                          .read<ProfileViewModel>()
                          .profileModel!
                          .accountType!
                          .toLowerCase() ==
                      "normal"
                  ? head(context)
                  : Container(),
              context
                          .read<ProfileViewModel>()
                          .profileModel!
                          .accountType!
                          .toLowerCase() ==
                      "normal"
                  ? const SizedBox(
                      height: 6,
                    )
                  : Container(),
              context
                          .read<ProfileViewModel>()
                          .profileModel!
                          .accountType!
                          .toLowerCase() ==
                      "normal"
                  ? Divider(
                      color: PColors.whiteOff.withOpacity(0.3),
                    )
                  : Container(),
              PlanListUi(),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget head(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, value, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 46,
                  backgroundColor: PColors.white,
                  child: CircleAvatar(
                    radius: 44,
                    backgroundImage:
                        value.profileModel!.profileImageUrl!.isEmpty
                            ? AssetImage(PImages.profile)
                            : NetworkImage(
                                value.profileModel!.profileImageUrl ?? ''),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textWidget(text: value.profileModel!.name ?? ''),
                const SizedBox(
                  height: 2,
                ),
                textWidget(
                    text: value.profileModel!.email ?? '',
                    fontsize: 12,
                    color: PColors.white.withOpacity(0.6))
              ],
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pushNamed(PPages.editProfileUi);
                    },
                    child: SvgPicture.asset(PSvgs.edit_profile)),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
