import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:go_router/go_router.dart';
import 'package:biz_zinda/Settings/until/PPages.dart';
import 'package:biz_zinda/Settings/until/PSvgs.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/view/connect_pages/map_section/view/widgets/result_freelancers.dart';
import 'package:biz_zinda/view_model/connect_page_view_model.dart';
import 'package:provider/provider.dart';

class ResultSheetUi extends StatelessWidget {
  ResultSheetUi({super.key});
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    ConnectPageViewModel connectPageViewModel =
        context.watch<ConnectPageViewModel>();
    return DraggableScrollableSheet(
      key: _sheet,

      initialChildSize: 0.15,
      minChildSize: 0.1,
      maxChildSize: 1,
      expand: false,
      snap: true,
      // snapSizes: const [0.5],
      snapSizes: const [
        0.55,
        // 1,
      ],
      controller: _controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: PColors.black,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(23), topRight: Radius.circular(23))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    width: 90,
                    decoration: BoxDecoration(
                        color: PColors.whiteOff.withOpacity(
                          0.5,
                        ),
                        borderRadius: BorderRadius.circular(3)),
                    height: 6,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(
                                text: "Showing total results",
                                color: PColors.white,
                                fontsize: 14),
                            textWidget(
                                text: "${connectPageViewModel.nearestStores.length} Stores available",
                                fontsize: 20,
                                fontweight: FontWeight.w500,
                                color: PColors.white),
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            context.pushNamed(PPages.freelancerFilterPageUi);
                          },
                          child: SvgPicture.asset(PSvgs.filter))
                    ],
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: connectPageViewModel.nearestStores.length,
                      controller: scrollController, // set this too
                      itemBuilder: (_, index) => ResultFreelancersSingleUi(
                        storeModel: connectPageViewModel.nearestStores[index],
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // List list = [
  //   {
  //     'cover': PImages.cover_pic1,
  //     'profile': PImages.pro_pic3,
  //     'name': "Jessica12"
  //   },
  //   {
  //     'cover': PImages.cover_pic2,
  //     'profile': PImages.pro_pic2,
  //     'name': "Jessica12"
  //   },
  //   {
  //     'cover': PImages.cover_pic1,
  //     'profile': PImages.pro_pic3,
  //     'name': "Jessica12"
  //   },
  //   {
  //     'cover': PImages.cover_pic2,
  //     'profile': PImages.pro_pic2,
  //     'name': "Jessica12"
  //   },
  //   {
  //     'cover': PImages.cover_pic1,
  //     'profile': PImages.pro_pic3,
  //     'name': "Jessica12"
  //   },
  // ];
}
