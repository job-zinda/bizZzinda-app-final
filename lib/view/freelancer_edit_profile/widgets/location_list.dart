import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/location_view_model.dart';
import 'package:provider/provider.dart';

class LocationListUi extends StatelessWidget {
  String? page;
  LocationListUi({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, value, child) => ListView.builder(
        shrinkWrap: true,
        itemCount: value.locationList.length,
        itemBuilder: (context, index) => ListTile(
            onTap: () {
              value.getPlaceDetails(
                  value.locationList[index]["place_id"],
                  context,
                  page!,
                  value.locationList[index]['structured_formatting']
                      ['main_text']);
            },
            shape: Border(
              bottom: BorderSide(color: PColors.white),
            ),
            title: textWidget(
                text: value.locationList[index]["description"],
                color: PColors.white,
                fontweight: FontWeight.w600)),
      ),
    );
  }

  // List list = [
  //   "Whitefield,Bengaluru",
  //   "Whitefield Bustop",
  //   "Whitefield,Metro",
  //   "Whitefield Bus Stop State Highway S.."
  // ];
}
