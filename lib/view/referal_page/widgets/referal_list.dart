import 'package:flutter/material.dart';
import 'package:biz_zinda/Settings/until/PColors.dart';
import 'package:biz_zinda/Settings/until/PImages.dart';
import 'package:biz_zinda/Settings/widgets/text_widget.dart';
import 'package:biz_zinda/model/referal_model.dart';
import 'package:biz_zinda/view_model/referal_view_model.dart';
import 'package:provider/provider.dart';

class ReferredList extends StatelessWidget {
  const ReferredList({super.key});

  // Fazur Nalim

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Consumer<ReferalViewModel>(
        builder: (context, value, child) =>

             value.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
            : value.referlaList.isEmpty
                ? const Expanded(
                    // height: 300,
                    child: Center(
                        child: Text(
                      "No Data!!!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                  )
                :
            Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                  text: "My Referrals",
                  fontsize: 20,
                  fontweight: FontWeight.w700),
              const SizedBox(
                height: 5,
              ),
              Expanded(child: main(context, size))
            ],
          ),
        ),
      ),
    );
  }

  Widget main(BuildContext context, Size size) {
    // var model = context.read<ProductsViewModel>();
    return Consumer<ReferalViewModel>(
      builder: (context, value, child) =>
          NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.atEdge &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            // User has reached the end of the list
            // Load more data or trigger pagination in flutter
            value.fetchPaginatedRefrelas();
          }

          return false;
        },
        child: ListView.builder(
          shrinkWrap: true,
          // physics: AlwaysScrollableScrollPhysics(),
          itemCount: value.referlaList.length+1,
          itemBuilder: (context, index) {
            if (index < value.referlaList.length) {
              return singleItem(referal: value.referlaList[index]);
            } else {
              if (value.isPaginationloading) {
                return value.hasMore
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : textWidget(text: "No more data to load!!!");
              }

              // return paginationLoad(context);
            }

            return null;
          },
        ),
      ),
    );
  }

  Widget singleItem({required Referrals referal}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            // backgroundImage: AssetImage(PImages.profile),
            backgroundImage: referal.referredUser!.profileImageUrl!.isEmpty
                ? AssetImage(PImages.profile)
                : NetworkImage(referal.referredUser!.profileImageUrl!),
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: referal.referredUser!.name ?? '',
                    // text:"Anusha djjs msdjzsdnsd nzsd nzs dnzs dnz sdz sdb zsd zs",
                    fontsize: 15,
                    fontweight: FontWeight.bold,
                    color: PColors.white),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: PColors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 2),
                    child: Center(
                        child: textWidget(
                            text: referal.referredUser!.referralCode ?? '',
                            // text:"F4f5gtyhu",
                            fontsize: 10,
                            color: PColors.black)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
