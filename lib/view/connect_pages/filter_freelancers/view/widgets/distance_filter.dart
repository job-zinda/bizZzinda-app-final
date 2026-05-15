import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view_model/connect_page_view_model.dart';
import 'package:provider/provider.dart';

class DistanceFilterUi extends StatelessWidget {
  DistanceFilterUi({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20
        ),
        textWidget(text: "Distance"),
        const SizedBox(
          height: 10,
        ),
        distanceFilter(size, context),
      ],
    );
  }

  Widget distanceFilter(Size size, BuildContext context) {
    return Consumer<ConnectPageViewModel>(
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          list.length,
          (index) => GestureDetector(
            onTap: () {
              context
                  .read<ConnectPageViewModel>()
                  .updateDistanceInKm2(list[index]);
            },
            child: Container(
              width: size.width / 3.4,
              height: 37,
              decoration: BoxDecoration(
                  color: value.distanceInKm == list[index]
                      ? PColors.seed2
                      : PColors.black2.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: textWidget(
                      text: "${list[index]} Km",
                      color: value.distanceInKm == list[index]
                          ? PColors.white
                          : PColors.whiteOff.withOpacity(0.5))),
            ),
          ),
        ),
      ),
    );
  }

  List list = [
    "10",
    "20",
    "30",
  ];
}
