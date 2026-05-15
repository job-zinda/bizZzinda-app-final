import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/widgets/safe_cached_network_image.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/analytics_model.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/date_formatter.dart';
import 'package:biz_zinda/view_model/profile_analytics_view_model.dart';
import 'package:provider/provider.dart';

class ProfileAnalyticsHeadUi extends StatefulWidget {
  const ProfileAnalyticsHeadUi({super.key});

  @override
  State<ProfileAnalyticsHeadUi> createState() => _ProfileAnalyticsHeadUiState();
}

class _ProfileAnalyticsHeadUiState extends State<ProfileAnalyticsHeadUi> {
  String dropdownValue = 'Last 7 days';

  @override
  Widget build(BuildContext context) {
    ProfileAnalyticsViewModel profileAnalyticsViewModel =
        context.watch<ProfileAnalyticsViewModel>();
    AnalyticsModel? analyticsModel = profileAnalyticsViewModel.analyticsModel;
    String today =
        formatDateFromDate(dateTime: DateTime.now(), format: 'MMM dd');
    String beforeOneMonth = formatDateFromDate(
        dateTime: DateTime.now().subtract(const Duration(days: 30)),
        format: 'MMM dd');
    String beforeOneWeek = formatDateFromDate(
        dateTime: DateTime.now().subtract(const Duration(days: 7)), format: 'MMM dd');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dropdownWidget(),
              Text(
                '${dropdownValue == 'Last 7 days' ? beforeOneWeek : beforeOneMonth} - $today',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: PColors.white,
                child: CircleAvatar(
                    radius: 28,
                    backgroundImage: (LoggedInUser.profilePic == null || LoggedInUser.profilePic!.isEmpty)
                         ? AssetImage(PImages.profile)
                         : safeImageProvider(LoggedInUser.profilePic, placeholderAsset: PImages.profile)),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                    text: 'Total followers',
                    color: PColors.whiteOff.withOpacity(0.9),
                  ),
                  Row(
                    children: [
                      Text(
                        '${analyticsModel?.totalFollowers ?? '0'} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.green[100],
                        child: const Center(
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                            size: 13,
                          ),
                        ),
                      ),
                      Text(
                        ' ${analyticsModel?.followersGrowth ?? '0%'}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget dropdownWidget() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
          color: PColors.black2, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButton<String>(
          value: dropdownValue,
          dropdownColor: PColors.seed2,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: PColors.white,
          ),
          //
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: PColors.seed2),
          underline: Container(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                dropdownValue = newValue;
              });
              if (newValue == 'Last 7 days') {
                context
                    .read<ProfileAnalyticsViewModel>()
                    
                    .fetchProfileAnalytics(filter: '7days');
              } else {
                context
                    .read<ProfileAnalyticsViewModel>()
                    .fetchProfileAnalytics(filter: '1month');
              }
            }
          },
          items: <String>['Last 7 days', 'Last 1 month']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: textWidget(text: value, color: PColors.white),
            );
          }).toList(),
        ),
      ),
    );
  }
}
