import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../../../model/analytics_model.dart';
import '../../../../view_model/profile_analytics_view_model.dart';

class GrowthSectionUi extends StatelessWidget {
  const GrowthSectionUi({super.key});

  @override
  Widget build(BuildContext context) {
      ProfileAnalyticsViewModel profileAnalyticsViewModel = context.watch<ProfileAnalyticsViewModel>();
    AnalyticsModel? analyticsModel =profileAnalyticsViewModel.analyticsModel;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 19),

          textWidget(
            text:'Growth',
            color: PColors.white,fontsize: 18,fontweight: FontWeight.w600
          ),
          const SizedBox(height: 10),
          itemWidget(title: 'Total new followers', value: '${analyticsModel?.filteredFollowers??'0'}'),
          const SizedBox(height: 10,),
          itemWidget(title: 'Unfollows', value: '${analyticsModel?.unFollowCount??'0'}'),
          const SizedBox(height: 10,),

          itemWidget(title: 'Profile view', value:'${analyticsModel?.totalProfileViews??'0'}'),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget itemWidget({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white,fontSize: 16),
        ),
      ],
    );
  }
}
