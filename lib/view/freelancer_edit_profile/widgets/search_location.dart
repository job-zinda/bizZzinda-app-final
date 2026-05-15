import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/custom_text_feild.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view/freelancer_edit_profile/widgets/location_list.dart';
import 'package:biz_zinda/view_model/location_view_model.dart';
import 'package:provider/provider.dart';

class SearchLocation extends StatelessWidget {
  String? page;
  SearchLocation({super.key, required this.page});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.seed,
      appBar: AppBar(
        backgroundColor: PColors.seed,
        centerTitle: true,
        title: textWidget(
            text: "Select a location",
            fontsize: 19,
            fontweight: FontWeight.w700,
            color: PColors.white),
      ),
      body: Consumer<LocationViewModel>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                searchButton(),
                const SizedBox(
                  height: 20,
                ),
                 LocationListUi(page: page,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchButton() {
    return Consumer<LocationViewModel>(
      builder: (context, value, child) => CustomTextFeild(
          onSubmitted: (val) {},
          controller: value.controller,
          borderRadius: 0,
          textColor: PColors.black,
          suffixIcon: const Icon(Icons.close),
          sufixfn: () {
            value.controller.clear();
            value.getLocationSuggestions("");

            // value.clearTextField();
          },
          prefixIcon: const Icon(Icons.search),
          prefixfn: () {},
          hintText: "Search Location",
          onSaved: (val) {},
          onChanged: (val) {
            value.getLocationSuggestions(val!);
          },
          validation: (val) {
            return null;
          },
          filColor: PColors.white),
    );
  }
}
