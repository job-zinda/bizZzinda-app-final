
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ReviewWidgetui extends StatefulWidget {
  String? profileId;
   ReviewWidgetui({super.key,required this.profileId});

  @override
  State<ReviewWidgetui> createState() => _ReviewWidgetuiState();
}

class _ReviewWidgetuiState extends State<ReviewWidgetui> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: PColors.seed2),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleSection(context),
              const SizedBox(
                height: 20,
              ),
              starSection(context),
              const SizedBox(
                height: 20,
              ),
              reviewWidget(),
              const SizedBox(
                height: 20,
              ),
              button()
            ],
          ),
        ),
      ),
    );
  }

  Widget titleSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.pushReplacementNamed(context, PPages.homePageUi);

            Navigator.pop(context);
          },
          child: CircleAvatar(
            radius: 20,
            // backgroundColor: PColors.lightgreyColor,
            child: const Center(
                child: Icon(
              Icons.close,
              size: 16,
            )),
          ),
        ),
        Expanded(child: Container()),
        textWidget(
            text: "Give a Rating ", fontsize: 20, fontweight: FontWeight.w600),
        Expanded(child: Container()),
      ],
    );
  }

  reviewWidget() {
    return CustomTextFeild(
      onSubmitted: (val){},
        controller: controller,
        hintText: "Write Review",
        textHead: "Detail Review",
        onSaved: (val) {},
        onChanged: (val) {},
        validation: (val) {
          return null;
        },
        maxLine: 5,
        filColor: PColors.textFeildBorderColor);
  }

  Widget button() {
    return CustomElavatedTextButton(
      borderRadius: 24,
      text: "Submit",
      onPressed: () {
        context.read<ProfileViewModel>().addProfileRating(context: context,
        profileId: widget.profileId!,
            rating: rating.toString(), review: controller.text);
      },
    );
  }

  double rating = 1;
  Widget starSection(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StarRating(
          rating: rating,
          size: 45,
          color: PColors.yellow,
          starCount: 5,
          allowHalfRating: true,
          onRatingChanged: (rating) => setState(() => this.rating = rating),
        )
      ],
    );
  }
}
