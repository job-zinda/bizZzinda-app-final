import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/help_support.dart';
import 'package:provider/provider.dart';

class SendFeedbackUi extends StatefulWidget {
  const SendFeedbackUi({super.key});

  @override
  State<SendFeedbackUi> createState() => _SendFeedbackUiState();
}

class _SendFeedbackUiState extends State<SendFeedbackUi> {
  TextEditingController controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: textWidget(text: "Send feedback"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    textWidget(
                      text: "Write your feedback below",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFeild(
                      controller: controller,
                        borderRadius: 0,
                        maxLine: 10,
                        hintText: "",
                        onSaved: (val) {},
                        onChanged: (val) {},
                        validation: (val) {
                          return null;
                        },
                        filColor: PColors.seed),
                    const SizedBox(
                      height: 30,
                    ),
                    starSection(context)
                  ],
                ),
              ),
            ),
            button(),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  Widget button() {
    return CustomElavatedTextButton(
      width: double.infinity,
      text: "Send",
      onPressed: () {
        context.read<HelpViewModel>().sendFeedback(rating:rating.toString() ,review:controller.text );
        controller.clear();
      },
      bgcolor: PColors.white,
      textColor: PColors.black,
      borderRadius: 0,
    );
  }

  double rating = 1;

  Widget starSection(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textWidget(text: "Optional",color: PColors.white.withOpacity(0.6)),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 7),
              child: StarRating(
                rating: rating,
                size: 45,
                
                borderColor: PColors.yellow,
                color: PColors.yellow,
                starCount: 5,
                allowHalfRating: true,
                onRatingChanged: (rating) => setState(() => this.rating = rating),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        textWidget(text: "Rate your experience with Job Zinda")
      ],
    );
  }
}
