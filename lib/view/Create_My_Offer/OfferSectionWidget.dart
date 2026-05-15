
import 'dart:io';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:biz_zinda/view/chat_bizzinda/chat_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:biz_zinda/view/Create_My_Offer/offer_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'offermodel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:biz_zinda/view/edit_profile/view/edit_profile_screen.dart';


class OfferSection extends StatefulWidget {
  final String id;
  const OfferSection({super.key, required this.id,});

  @override
  State<OfferSection> createState() => _OfferSectionState();
}

class _OfferSectionState extends State<OfferSection> {
  bool _isChatLoading = false;
  late Razorpay _razorpay;
  void _showDeleteDialog(BuildContext context, String offerId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Delete Offer"),
        content: const Text("Are you sure you want to delete this offer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(ctx);

              await context.read<OfferViewModel>().removeOffer(
                offerId: offerId,
                context: context,
              );
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    context.read<OfferViewModel>().verifyPromotionPayment(
      orderId: response.orderId!,
      paymentId: response.paymentId!,
    );

    setState(() {});
  }

  void _handleError(PaymentFailureResponse response) {
    print("❌ Payment Failed");
  }

  void openCheckout(Map<String, dynamic> data) {
    var options = {
      'key': data['key_id'],
      'amount': data['amount'],
      // 'amount': 100,
      'currency': data['currency'],
      'name': 'JobZinda',
      'description': 'Offer Promotion',
      'order_id': data['orderId'],
    };

    _razorpay.open(options);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  String timeAgo(String? date) {
    if (date == null) return "";

    final now = DateTime.now();
    final created = DateTime.parse(date).toLocal();
    final diff = now.difference(created);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    if (diff.inDays == 1) return "Yesterday";
    if (diff.inDays < 7) return "${diff.inDays} days ago";

    return "${created.day}/${created.month}/${created.year}";
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OfferViewModel>();

    return PagedListView<int, OfferingModel>(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      pagingController: vm.offerController,
      builderDelegate: PagedChildBuilderDelegate<OfferingModel>(
        itemBuilder: (context, offer, index) {
          return Container(
            key: ValueKey(offer.id), // ✅ VERY IMPORTANT
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// USER INFO
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: offer.userProfile != null &&
                        offer.userProfile!.isNotEmpty
                        ? NetworkImage(offer.userProfile!)
                        : null,
                    child: offer.userProfile == null ||
                        offer.userProfile!.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    offer.userName ?? "No Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    timeAgo(offer.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  trailing: offer.userId == LoggedInUser.id
                      ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog(context, offer.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
                  )
                      : null,
          ),




                /// IMAGE
                if (offer.mediaType == 'image')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      offer.mediaUrl ?? "",
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),

                /// DESCRIPTION
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    offer.bio ?? "",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: offer.userId == LoggedInUser.id
                            ? [Colors.orange.shade400, Colors.orange.shade600] // Promote
                            : [Colors.orange.shade400, Colors.orange.shade600],    // Chat
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: (offer.userId == LoggedInUser.id
                              ? Colors.orange
                              : Colors.orange.shade400)
                              .withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {

                          /// 🔒 prevent double click
                          if (_isChatLoading) return;

                          setState(() {
                            _isChatLoading = true;
                          });

                          try {

                            /// 🔥 OWN OFFER -> PROMOTE
                            if (offer.userId == LoggedInUser.id) {

                              final data = await context
                                  .read<OfferViewModel>()
                                  .initiatePromotion(offer.id);

                              if (data != null) {
                                openCheckout(data);
                              }

                            } else {

                              /// 🔥 START CHAT
                              final response = await ApiService().post(
                                "${AppUrl.baseurl}/api/v1/biz-chat/initiateChat",
                                {
                                  "shopId": offer.userId,
                                  "offeringId": offer.id,
                                  "recipientUserId": offer.userId,
                                },
                              );

                              print("CHAT RESPONSE => ${response.data}");

                              if (response.statusCode == 200 &&
                                  response.data['status'] == true) {

                                final conversationId =
                                    response.data['data']['conversationId']?.toString() ?? "";

                                if (conversationId.isEmpty) {
                                  EasyLoading.showError("Conversation not found");
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      conversationId: conversationId,
                                    ),
                                  ),
                                );

                              } else {

                                EasyLoading.showError(
                                  response.data['message'] ?? "Unable to start chat",
                                );
                              }
                            }

                          } catch (e) {

                            print("CHAT ERROR => $e");

                            EasyLoading.showError("Something went wrong");

                          } finally {

                            if (mounted) {
                              setState(() {
                                _isChatLoading = false;
                              });
                            }
                          }
                        },
                        // onTap: () async {
                        //   if (offer.userId == LoggedInUser.id) {
                        //     /// 🔥 PROMOTE (OWN OFFER)
                        //     final data = await context
                        //         .read<OfferViewModel>()
                        //         .initiatePromotion(offer.id);
                        //
                        //     if (data != null) {
                        //       openCheckout(data);
                        //     }
                        //   } else {
                        //     final headers = await LoggedInUser.getAuthorizationHeader();
                        //     print("HEADERS: $headers");
                        //
                        //     try {
                        //       final response = await ApiService().post(
                        //         "${AppUrl.baseurl}/api/v1/biz-chat/initiateChat",
                        //         {
                        //           // "shopId": shopVM.shopModel?.id,  // 👈 MUST ADD
                        //           "offeringId": offer.id,
                        //         },
                        //       );
                        //
                        //       print("USER ID: ${offer.userId}");
                        //
                        //       if (response.statusCode == 200) {
                        //         final conversationId = response.data['data']['conversationId'];
                        //
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (_) => EditProfileScreen(),
                        //           ),
                        //         );
                        //       }
                        //     } catch (e) {
                        //       if (e is DioException) {
                        //         print("❌ ERROR: ${e.response?.data}");
                        //       }
                        //     }
                        //   }
                        // },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                offer.userId == LoggedInUser.id
                                    ? Icons.campaign
                                    : Icons.chat_bubble_outline,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                offer.userId == LoggedInUser.id
                                    ? "Promote"
                                    : "Chat Now",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          // Padding(
          //            padding: const EdgeInsets.symmetric(horizontal: 10),
          //            child: ElevatedButton(
          //              style: ElevatedButton.styleFrom(
          //                backgroundColor: Colors.white,
          //                minimumSize: const Size(double.infinity, 45),
          //                shape: RoundedRectangleBorder(
          //                  borderRadius: BorderRadius.circular(8),
          //                  side: const BorderSide(
          //                    color: Colors.orange,
          //                    width: 1,
          //                  ),
          //                ),
          //              ),
          // onPressed: () async {
          // final headers = await LoggedInUser.getAuthorizationHeader();
          //
          // await Dio().post(
          // "${AppUrl.baseurl}/api/v1/biz-chat/initiateChat",
          // data: {
          // // "shopId": shop.id,        // ✅ use this
          // "offeringId": offer.id,
          // },
          // options: Options(headers: {
          // ...headers,
          // "verifyPlatform": "bizzinda",
          // }),
          // );
          // },
          //              child: const Text("Chat Now",style: TextStyle(color:Colors.black),),           ),
          //         ),

                SizedBox(height: 10,),

                /// PROMOTE BUTTON ROW
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      /// LIKE
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              bool success = await context
                                  .read<OfferViewModel>()
                                  .likeOffering(offer.id);

                              if (success) {
                                setState(() {
                                  offer.isLiked = !(offer.isLiked ?? false);

                                  if (offer.isLiked == true) {
                                    offer.likesCount = (offer.likesCount ?? 0) + 1;
                                  } else {
                                    offer.likesCount = (offer.likesCount ?? 0) - 1;
                                  }
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  offer.isLiked == true
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_alt_outlined,
                                  size: 18,
                                  color:
                                  offer.isLiked == true ? Colors.blue : Colors.orange,
                                ),
                                const SizedBox(width: 5),
                                Text("${offer.likesCount ?? 0}"),
                              ],
                            ),
                          )
                        ],
                      ),

                      /// PROMOTE BUTTON (NOW SAFE)
                      // if (offer.userId == LoggedInUser.id)
                      //   InkWell(
                      //     onTap: () async {
                      //       final data = await context
                      //           .read<OfferViewModel>()
                      //           .initiatePromotion(offer.id!);
                      //
                      //       if (data != null) {
                      //         openCheckout(data);
                      //       }
                      //     },
                      //     child: Container(
                      //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      //       decoration: BoxDecoration(
                      //         color: Colors.orange.shade50,
                      //         borderRadius: BorderRadius.circular(20),
                      //         border: Border.all(color: Colors.orange),
                      //       ),
                      //       child: const Row(
                      //         children: [
                      //           Icon(Icons.campaign, size: 18, color: Colors.black),
                      //           SizedBox(width: 5),
                      //           Text(
                      //             "Promote",
                      //             style: TextStyle(color: Colors.orange),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   )
                      // else
                      //   const SizedBox.shrink(),

                      /// SHARE
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              final String shareUrl =
                                  "https://server2.jobzinda.com/offering/${offer.id}";

                              final String text = """
                                🔥 Check this offer!

                                 ${offer.bio ?? ''}

                                 👉 Open Offer:
                                        $shareUrl
                                                    """;

                              try {
                                if (offer.mediaUrl != null &&
                                    offer.mediaUrl!.isNotEmpty) {

                                  final response =
                                  await http.get(Uri.parse(offer.mediaUrl!));

                                  final tempDir =
                                  await getTemporaryDirectory();

                                  final file =
                                  File('${tempDir.path}/offer.jpg');

                                  await file.writeAsBytes(response.bodyBytes);

                                  await Share.shareXFiles(
                                    [XFile(file.path)],
                                    text: text,
                                  );
                                } else {
                                  await Share.share(text);
                                }

                                final newCount = await context
                                    .read<OfferViewModel>()
                                    .increaseShareCount(offer.id);

                                if (newCount != null && mounted) {
                                  setState(() {
                                    offer.shareCount = newCount;
                                  });
                                }
                              } catch (e) {
                                debugPrint("Share error: $e");
                                await Share.share(text);
                              }
                            },
                            // onTap: () async {
                            //   final String shareUrl =
                            //       "https://server2.jobzinda.com/api/v1/offering/share/${offer.id}";
                            //
                            //
                            //
                            //   final String playStoreLink =
                            //       "https://play.google.com/store/apps/details?id=com.biz_zinda.app";
                            //
                            //   final String text =
                            //       "🔥 Check this offer!\n\n"
                            //       "${offer.bio ?? ''}\n\n"
                            //       "👉 View Offer: $shareUrl\n"
                            //       "📲 Install App: $playStoreLink";
                            //
                            //   try {
                            //     // 🔹 SHARE PART
                            //     if (offer.mediaUrl != null && offer.mediaUrl!.isNotEmpty) {
                            //       final response = await http.get(Uri.parse(offer.mediaUrl!));
                            //
                            //       final tempDir = await getTemporaryDirectory();
                            //       final file = File('${tempDir.path}/offer.jpg');
                            //
                            //       await file.writeAsBytes(response.bodyBytes);
                            //
                            //       await Share.shareXFiles(
                            //         [XFile(file.path)],
                            //         text: text,
                            //       );
                            //     } else {
                            //       await Share.share(text);
                            //     }
                            //
                            //     // 🔥 SHARE COUNT UPDATE (after share)
                            //     final newCount = await context
                            //         .read<OfferViewModel>()
                            //         .increaseShareCount(offer.id);
                            //
                            //     if (newCount != null) {
                            //       setState(() {
                            //         offer.shareCount = newCount;
                            //       });
                            //     }
                            //   } catch (e) {
                            //     print("Share error: $e");
                            //     await Share.share(text);
                            //   }
                            // },
                            // onTap: () async {
                            //   final String offerLink =
                            //       "https://server2.jobzinda.com/api/v1/offering/share/${offer.id}";
                            //
                            //   final String playStoreLink =
                            //       "https://play.google.com/store/apps/details?id=com.biz_zinda.app";
                            //
                            //   final String text =
                            //       "🔥 Check this offer!\n\n"
                            //       "${offer.bio ?? ''}\n\n"
                            //       "👉 View Offer: $offerLink\n"
                            //       "📲 Install App: $playStoreLink";
                            //
                            //   try {
                            //     // 🔹 SHARE PART
                            //     if (offer.mediaUrl != null && offer.mediaUrl!.isNotEmpty) {
                            //       final response =
                            //       await http.get(Uri.parse(offer.mediaUrl!));
                            //
                            //       final tempDir = await getTemporaryDirectory();
                            //       final file = File('${tempDir.path}/offer.jpg');
                            //
                            //       await file.writeAsBytes(response.bodyBytes);
                            //
                            //       await Share.shareXFiles(
                            //         [XFile(file.path)],
                            //         text: text,
                            //       );
                            //     } else {
                            //       await Share.share(text);
                            //     }
                            //
                            //     // 🔥 👉 THIS PART PLACE HERE (AFTER SHARE)
                            //     final newCount = await context
                            //         .read<OfferViewModel>()
                            //         .increaseShareCount(offer.id);
                            //
                            //      if (newCount != null) {
                            //       setState(() {
                            //         offer.shareCount = newCount;
                            //        });
                            //      }
                            //
                            //   } catch (e) {
                            //     print("Share error: $e");
                            //     await Share.share(text);
                            //   }
                            // },

                            child: Row(
                              children: [
                                const Icon(Icons.share_outlined, size: 18),
                                const SizedBox(width: 5),
                                Text("${offer.shareCount ?? 0}"),
                              ],
                            ),
                          )],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
// import 'package:biz_zinda/view/Create_My_Offer/offer_veiw_model.dart';
// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:provider/provider.dart';
// import 'offermodel.dart';
//
// class OfferSection extends StatelessWidget {
//   const OfferSection({super.key});
//   void _showDeleteDialog(BuildContext context, String offerId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: Colors.orange.shade100,
//         title: const Text("Delete Offer"),
//         content: const Text("Are you sure you want to delete this offer?",style:TextStyle(color: Colors.black) ,),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//
//               context.read<OfferViewModel>().removeOffer(
//                 offerId: offerId,
//                 context: context,
//               );
//             },
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );
//   }
//   String timeAgo(String? date) {
//     if (date == null) return "";
//
//     final now = DateTime.now();
//     final created = DateTime.parse(date).toLocal();
//     final diff = now.difference(created);
//
//     if (diff.inSeconds < 60) {
//       return "Just now";
//     } else if (diff.inMinutes < 60) {
//       return "${diff.inMinutes} min ago";
//     } else if (diff.inHours < 24) {
//       return "${diff.inHours} hr ago";
//     } else if (diff.inDays == 1) {
//       return "Yesterday";
//     } else if (diff.inDays < 7) {
//       return "${diff.inDays} days ago";
//     } else {
//       return "${created.day}/${created.month}/${created.year}";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<OfferViewModel>();
//
//     return PagedListView<int, OfferingModel>(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       pagingController: vm.offerController,
//       builderDelegate: PagedChildBuilderDelegate<OfferingModel>(
//           itemBuilder: (context, offer, index) {
//             return Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.orange.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     blurRadius: 6,
//                     spreadRadius: 2,
//                   )
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   /// 🔹 TOP USER INFO
//                   ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: offer.userProfile != null &&
//                           offer.userProfile!.isNotEmpty
//                           ? NetworkImage(offer.userProfile!)
//                           : null,
//                       child: offer.userProfile == null || offer.userProfile!.isEmpty
//                           ? Icon(Icons.person)
//                           : null,
//                     ),
//                     title: Text(
//                       (offer.userName != null && offer.userName!.isNotEmpty)
//                           ? offer.userName!
//                           : "No Name",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       timeAgo(offer.createdAt),
//                       style: TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//
//                     // subtitle: const Text("Sponsored"),
//                     trailing: PopupMenuButton<String>(
//                       onSelected: (value) {
//                         if (value == 'delete') {
//                           _showDeleteDialog(context, offer.id!);
//                         }
//                       },
//                       itemBuilder: (context) => [
//                         const PopupMenuItem(
//                           value: 'delete',
//                           child: Text(
//                             "Delete",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       ],
//                       child: const Icon(Icons.more_vert),
//                     ),
//                   ),
//
//                   /// 🔹 IMAGE
//                   if (offer.mediaType == 'image')
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         offer.mediaUrl ?? "",
//                         width: double.infinity,
//                         height: 220,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//
//                     Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Text(
//                       offer.bio ?? "",
//                       style: const TextStyle(fontSize: 16,color: Colors.black),
//                     ),
//                   ),
//
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:Color(0xFFFB8C00), // Facebook blue
//                         minimumSize: const Size(double.infinity, 45),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: () {
//                         // action (open link / contact)
//                       },
//                       child: const Text("Chat Now",style: TextStyle(color:Colors.black),),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                    Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.thumb_up_alt_outlined, size: 18),
//                             SizedBox(width: 5),
//                             Text("${offer.likesCount ?? 0}"),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//
//                             GestureDetector(
//                               onTap: () {
//                                 if (offer.id != null) {
//                                   context.read<OfferViewModel>().promoteOffer(offer.id!);
//                                 } else {
//                                   print("❌ Offer ID null");
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.orange.shade50,
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(color: Colors.orange),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.campaign, size: 18, color: Colors.black),
//                                     SizedBox(width: 5),
//                                     Text(
//                                       "Promote",
//                                       style: TextStyle(color: Colors.orange),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.share_outlined, size: 18),
//                             SizedBox(width: 5),
//                             Text("${offer.shareCount ?? 0}"),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//                 ],
//               ),
//             );
//           },
//
//         // Progress, error, no items
//         firstPageProgressIndicatorBuilder: (_) =>
//         const Center(child: CircularProgressIndicator()),
//         firstPageErrorIndicatorBuilder: (_) =>
//         const Center(child: Text("Error loading offers")),
//         noItemsFoundIndicatorBuilder: (_) =>
//         const Center(child: Text("No offers found")),
//       ), // <-- Close PagedChildBuilderDelegate
//     ); // <-- Close PagedListView
//   }
// }