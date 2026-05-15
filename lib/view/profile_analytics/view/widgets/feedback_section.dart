import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../../../model/analytics_model.dart';
import '../../../../view_model/profile_analytics_view_model.dart';

class FeedbackSectionUi extends StatelessWidget {
  const FeedbackSectionUi({super.key});

  @override
  Widget build(BuildContext context) {
        ProfileAnalyticsViewModel profileAnalyticsViewModel = context.watch<ProfileAnalyticsViewModel>();
    AnalyticsModel? analyticsModel =profileAnalyticsViewModel.analyticsModel;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
    
              textWidget(
                  text: 'Feedbacks',
                  color: PColors.white,
                  fontsize: 18,
                  fontweight: FontWeight.w600),
              const SizedBox(height: 10),
              itemWidget(title: 'Total feedbacks', value: '${analyticsModel?.totalFeedback?.totalRatings??'0'}'),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Divider(
          color: PColors.whiteOff.withOpacity(0.4),
        ),
    
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
           textWidget(
              text: 'Projects',
              color: PColors.white,
              fontsize: 18,
              fontweight: FontWeight.w600),
          const SizedBox(height: 10),
          itemWidget(title: 'Total projects handled', value: '${analyticsModel?.totalProjects??'0'}'),
         
          ],),
        )
       
      ],
    );
  }

  Widget itemWidget({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWidget(
         text:  title,
          color: PColors.white.withOpacity(0.6),
        ),
       textWidget(text: value,fontweight: FontWeight.w600,fontsize: 17)
      ],
    );
  }
}
