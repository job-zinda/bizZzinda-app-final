import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/view/profile_view/view/widgets/profile_view_body.dart';
import 'package:biz_zinda/view/wrapper/view_model/view_model.dart';
import 'package:provider/provider.dart';

class ProfileViewUi extends StatelessWidget {
  const ProfileViewUi({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context
            .read<WrapperViewModel>()
            .updatePageView(WrapperViewStatus.profile);
        return false;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomElavatedTextButton(
          bgcolor: PColors.white,
          textColor: Color(0xFFFB8C00),
          borderColor: Color(0xFFFB8C00),
          borderRadius: 18,
          text: "Lets go",
          onPressed: () {
            context.pushNamed(PPages.editProfileUi);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              head(context),
              const SizedBox(
                height: 6,
              ),
              Divider(
                color: PColors.whiteOff.withOpacity(0.3),
              ),
              const SizedBox(
                height: 10,
              ),
              const ProfileViewBodyUi(),
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
    return Container(
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
                  backgroundImage: NetworkImage(LoggedInUser.profilePic ?? ''),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              textWidget(text: LoggedInUser.name ?? ''),
              const SizedBox(
                height: 2,
              ),
              textWidget(
                  text: LoggedInUser.email ?? '',
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
    );
  }
}
