import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_elevated_button.dart';
import 'package:biz_zinda/view/connect_pages/filter_freelancers/view/widgets/distance_filter.dart';
import 'package:biz_zinda/view/connect_pages/filter_freelancers/view/widgets/gender_filter_widget.dart';
import 'package:biz_zinda/view/connect_pages/filter_freelancers/view/widgets/projects_filter.dart';
import 'package:biz_zinda/view/connect_pages/filter_freelancers/view/widgets/rating_filter.dart';

import 'package:biz_zinda/view_model/connect_page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:biz_zinda/view/store_location/store_model.dart';

class FreelancerFilterPageUi extends StatelessWidget {
  const FreelancerFilterPageUi({super.key});

  @override
  Widget build(BuildContext context) {
    ConnectPageViewModel connectPageViewModel =
        context.read<ConnectPageViewModel>();
    return Scaffold(
      floatingActionButton: CustomElavatedTextButton(
        borderRadius: 0,
        text: "Save",
        onPressed: () {
          Navigator.pop(context);
          connectPageViewModel.fetchNearestStores();
        },
        bgcolor: PColors.white,
        textColor:Color(0xFFFB8C00),
      ),
      appBar: AppBar(
        title: const Text(
          "Filter",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17),
        // child: ChangeNotifierProvider(
        //   create: (context) => FreelancerFilterViewModel(),
        //   builder: (context, child) =>
        child: SingleChildScrollView(
          child: Column(
            children: [
              DistanceFilterUi(),
              const SizedBox(height: 10),
              GenderFilterUi(),
              const SizedBox(height: 10),
              // ProjectsFilterUi(),
              // const SizedBox(height: 10),
              RatingFilterUi(),
              const SizedBox(height: 40),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
