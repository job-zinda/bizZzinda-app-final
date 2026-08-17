import 'dart:io';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:biz_zinda/view/Create_My_Offer/full_screen_vedeo.dart';
import 'package:biz_zinda/view/chat_bizzinda/chat_screen.dart';
import 'package:biz_zinda/view/my_profile/view/profile_screen.dart';
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
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
import 'package:biz_zinda/utils/contact_launcher.dart';
import 'package:biz_zinda/utils/guest_helper.dart';
import 'package:biz_zinda/view_model/post_view_model.dart';
import 'package:biz_zinda/view/edit_profile/view/edit_profile_screen.dart';
import 'package:video_player/video_player.dart';


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
  String _fullMediaUrl(String? url) {
    final mediaUrl = (url ?? "").trim();

    if (mediaUrl.isEmpty) return "";

    if (mediaUrl.startsWith("http://") || mediaUrl.startsWith("https://")) {
      return mediaUrl;
    }

    if (mediaUrl.startsWith("/")) {
      return "${AppUrl.baseurl}$mediaUrl";
    }

    return "${AppUrl.baseurl}/$mediaUrl";
  }
  Widget _buildMediaWidget(OfferingModel offer) {
    String mediaUrl = (offer.mediaUrl ?? "").trim();

    if (mediaUrl.isNotEmpty && !mediaUrl.startsWith("http")) {
      mediaUrl = "${AppUrl.baseurl}/$mediaUrl";
    }

    final mediaType = (offer.mediaType ?? "").toLowerCase();

    final bool isVideo =
        mediaType.contains('video') ||
            mediaUrl.toLowerCase().endsWith('.mp4') ||
            mediaUrl.toLowerCase().endsWith('.mov') ||
            mediaUrl.toLowerCase().endsWith('.mkv');

    /// VIDEO
    if (isVideo) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenVideoPage(
                videoUrl: mediaUrl,
              ),
            ),
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: CustomVideoPlayer(url: mediaUrl),
        ),
      );
    }

    /// IMAGE
    return Image.network(
      mediaUrl,
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          height: 300,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 300,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(
            Icons.broken_image,
            size: 50,
          ),
        );
      },
    );
  }
  // Widget _buildMediaWidget(OfferingModel offer) {
  //   print("MEDIA URL => ${offer.mediaUrl}");
  //   print("MEDIA TYPE => ${offer.mediaType}");
  //   final mediaUrl = offer.mediaUrl ?? "";
  //   final mediaType = (offer.mediaType ?? "").toLowerCase();
  //
  //   final bool isVideo =
  //       mediaType.contains('video') ||
  //           mediaUrl.endsWith('.mp4') ||
  //           mediaUrl.endsWith('.mov') ||
  //           mediaUrl.endsWith('.mkv');
  //
  //   if (isVideo) {
  //     return SizedBox(
  //       height: 250,
  //       width: double.infinity,
  //       child: CustomVideoPlayer(url: mediaUrl),
  //     );
  //   }
  //
  //   return Image.network(
  //     mediaUrl,
  //     width: double.infinity,
  //     height: 250,
  //     fit: BoxFit.cover,
  //     errorBuilder: (context, error, stackTrace) {
  //       return Container(
  //         height: 250,
  //         color: Colors.grey.shade200,
  //         child: const Center(
  //           child: Icon(Icons.broken_image, size: 50),
  //         ),
  //       );
  //     },
  //   );
  // }

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
    final String key = data['key_id'] ?? data['key'] ?? '';
    final dynamic amount = data['amount'];
    final String currency = data['currency'] ?? 'INR';
    final String orderId = data['orderId'] ?? data['order_id'] ?? data['id'] ?? '';

    var options = {
      'key': key,
      'amount': amount,
      'currency': currency,
      'name': 'JobZinda',
      'description': 'Offer Promotion',
      'order_id': orderId,
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

                ListTile(
                  onTap: () {
                    if (offer.userId == null) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtherUserProfileScreen(
                          userId: offer.userId!,
                        ),
                      ),
                    );
                  },

                  leading: CircleAvatar(
                    backgroundImage: offer.userProfile != null &&
                        offer.userProfile!.isNotEmpty
                        ? NetworkImage(offer.userProfile!)
                        : null,
                    child: (offer.userProfile == null || offer.userProfile!.isEmpty)
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
                    itemBuilder: (context) => const [
                      PopupMenuItem(
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
          //       ListTile(
          //         leading: CircleAvatar(
          //           backgroundImage: offer.userProfile != null &&
          //               offer.userProfile!.isNotEmpty
          //               ? NetworkImage(offer.userProfile!)
          //               : null,
          //           child: offer.userProfile == null ||
          //               offer.userProfile!.isEmpty
          //               ? const Icon(Icons.person)
          //               : null,
          //         ),
          //         title: Text(
          //           offer.userName ?? "No Name",
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //         subtitle: Text(
          //           timeAgo(offer.createdAt),
          //           style: const TextStyle(color: Colors.grey, fontSize: 12),
          //         ),
          //         trailing: offer.userId == LoggedInUser.id
          //             ? PopupMenuButton<String>(
          //           onSelected: (value) {
          //             if (value == 'delete') {
          //               _showDeleteDialog(context, offer.id);
          //             }
          //           },
          //           itemBuilder: (context) => [
          //             const PopupMenuItem(
          //               value: 'delete',
          //               child: Text(
          //                 "Delete",
          //                 style: TextStyle(color: Colors.red),
          //               ),
          //             ),
          //           ],
          //           child: const Icon(Icons.more_vert),
          //         )
          //             : null,
          // ),




                /// IMAGE
                // if (offer.mediaType == 'image')
                //   ClipRRect(
                //     borderRadius: BorderRadius.circular(10),
                //     child: Image.network(
                //       offer.mediaUrl ?? "",
                //       width: double.infinity,
                //       height: 220,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                /// MEDIA (IMAGE / VIDEO)
                if ((offer.mediaUrl ?? '').isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildMediaWidget(offer),
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
                          if (_isChatLoading) return;

                          setState(() {
                            _isChatLoading = true;
                          });

                          try {

                            if (offer.userId == LoggedInUser.id) {

                              final data = await context
                                  .read<OfferViewModel>()
                                  .initiatePromotion(offer.id);

                              if (data != null) {
                                openCheckout(data);
                              }

                            } else {

                              if (LoggedInUser.isGuest) {
                                String? wa = offer.whatsappNumber ?? offer.contactNumber;
                                if (wa == null || wa.trim().isEmpty) {
                                  await context.read<PostViewModel>().fetchOtherUserProfileDetails(userID: offer.userId);
                                  final otherUser = context.read<PostViewModel>().otherUser;
                                  wa = otherUser?.whatsappNumber ?? otherUser?.contactNumber;
                                }
                                if (wa != null && wa.trim().isNotEmpty) {
                                  final String imgUrl = _fullMediaUrl(offer.mediaUrl);
                                  final String msg = imgUrl.isNotEmpty
                                      ? "HI i found your offer in Biz Zinda\n$imgUrl"
                                      : "HI i found your offer in Biz Zinda";
                                  launchWhatsAppChat(wa, null, message: msg);
                                } else {
                                  isGuestUser(context);
                                }
                                return;
                              }

                              if (offer.userId == null ||
                                  offer.userId!.isEmpty ||
                                  offer.userId!.length != 24) {

                                EasyLoading.showError("Invalid user id");
                                return;
                              }

                              if (offer.id.isEmpty || offer.id.length != 24) {
                                EasyLoading.showError("Invalid offer id");
                                return;
                              }

                              /// 🔥 PAYLOAD
                              final payload = {
                                "recipientUserId": offer.userId.toString(),
                                "offeringId": offer.id.toString(),
                              };

                              print("CHAT PAYLOAD => $payload");

                              /// 🔥 API CALL
                              final response = await ApiService().post(
                                Api.initiateChat,
                                payload,
                              );

                              print("CHAT STATUS => ${response.statusCode}");
                              print("CHAT RESPONSE => ${response.data}");

                              /// 🔥 SUCCESS
                              if (response.statusCode == 200 &&
                                  response.data['status'] == true) {

                                final conversation =
                                response.data['data']['conversation'];

                                final String conversationId =
                                    conversation['_id']?.toString() ?? "";

                                print("CONVERSATION ID => $conversationId");

                                if (conversationId.isEmpty) {
                                  EasyLoading.showError("Conversation not found");
                                  return;
                                }

                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    // builder: (_) => ChatScreen(
                                    //   conversationId: conversationId,
                                    //   shopName: offer.userName ?? "Shop",
                                    //   offerImage: _fullMediaUrl(offer.mediaUrl),
                                    //   offerBio: offer.bio,
                                    //   userProfile: offer.userProfile,
                                    // ),
                                     builder: (_)=> ChatScreen(
                                        conversationId: conversationId,
                                        offeringId: offer.id,
                                        shopName: offer.userName ?? "Shop",
                                        offerImage: _fullMediaUrl(offer.mediaUrl),
                                        offerBio: offer.bio,
                                        userProfile: offer.userProfile,
                                      )
                                  ),
                                );

                              } else {

                                EasyLoading.showError(
                                  response.data['message'] ??
                                      "Unable to start chat",
                                );
                              }
                            }

                          } catch (e) {

                            if (e is DioException) {

                              print("ERROR STATUS => ${e.response?.statusCode}");
                              print("ERROR DATA => ${e.response?.data}");
                            }

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
                        //
                        //   /// 🔒 prevent double click
                        //   if (_isChatLoading) return;
                        //
                        //   setState(() {
                        //     _isChatLoading = true;
                        //   });
                        //
                        //   try {
                        //
                        //     /// 🔥 OWN OFFER -> PROMOTE
                        //     if (offer.userId == LoggedInUser.id) {
                        //
                        //       final data = await context
                        //           .read<OfferViewModel>()
                        //           .initiatePromotion(offer.id);
                        //
                        //       if (data != null) {
                        //         openCheckout(data);
                        //       }
                        //
                        //     } else {
                        //
                        //       /// 🔥 START CHAT
                        //       final response = await ApiService().post(
                        //         Api.initiateChat,
                        //         {
                        //           "recipientUserId": offer.userId,
                        //           "offeringId": offer.id,
                        //         },
                        //       );
                        //
                        //       print("CHAT RESPONSE => ${response.data}");
                        //
                        //       if (response.statusCode == 200 &&
                        //           response.data['status'] == true) {
                        //
                        //         final conversation =
                        //         response.data['data']['conversation'];
                        //
                        //         final String conversationId =
                        //             conversation['_id']?.toString() ?? "";
                        //
                        //         if (conversationId.isEmpty) {
                        //           EasyLoading.showError("Conversation not found");
                        //           return;
                        //         }
                        //
                        //         Navigator.of(context, rootNavigator: true).push(
                        //           MaterialPageRoute(
                        //             builder: (_) => ChatScreen(
                        //               conversationId: conversationId,
                        //               shopName: offer.userName ?? "Shop",
                        //               offerImage: offer.mediaUrl,
                        //               offerBio: offer.bio,
                        //               userProfile: offer.userProfile,
                        //             ),
                        //           ),
                        //         );
                        //       } else {
                        //
                        //         EasyLoading.showError(
                        //           response.data['message'] ?? "Unable to start chat",
                        //         );
                        //       }
                        //     }
                        //
                        //   } catch (e) {
                        //
                        //     print("CHAT ERROR => $e");
                        //
                        //     EasyLoading.showError("Something went wrong");
                        //
                        //   } finally {
                        //
                        //     if (mounted) {
                        //       setState(() {
                        //         _isChatLoading = false;
                        //       });
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

                                if (offer.id.isEmpty || offer.id.length != 24) {
                                  EasyLoading.showError("Invalid offer id");
                                  return;
                                }

                                final String shareUrl =
                                    "https://server2.jobzinda.com/offering/${offer.id.trim()}";

                                String? wa = offer.whatsappNumber ?? offer.contactNumber;
                                if (wa == null || wa.trim().isEmpty) {
                                  if (offer.userId == LoggedInUser.id) {
                                    wa = LoggedInUser.whatsappNumber ?? LoggedInUser.contactNumber;
                                  }
                                }
                                if (wa == null || wa.trim().isEmpty) {
                                   final String? uId = offer.userId;
                                   if (uId != null && uId.isNotEmpty) {
                                     await context.read<PostViewModel>().fetchOtherUserProfileDetails(userID: uId);
                                     final otherUser = context.read<PostViewModel>().otherUser;
                                     wa = otherUser?.whatsappNumber ?? otherUser?.contactNumber;
                                   }
                                 }

                                String whatsappLink = "";
                                if (wa != null && wa.trim().isNotEmpty) {
                                  String cleanNum = wa.replaceAll(RegExp(r'[^\d]'), '');
                                  if (!cleanNum.startsWith('91') && cleanNum.length == 10) {
                                    cleanNum = '91$cleanNum';
                                  }
                                  final String encodedMsg = Uri.encodeComponent("HI i found your offer in Biz Zinda");
                                  whatsappLink = "https://wa.me/$cleanNum?text=$encodedMsg";
                                }

                                final StringBuffer sb = StringBuffer();
                                sb.writeln("🔥 Check this offer!");
                                sb.writeln();
                                if ((offer.bio ?? '').isNotEmpty) {
                                  sb.writeln(offer.bio);
                                  sb.writeln();
                                }
                                if (whatsappLink.isNotEmpty) {
                                  sb.writeln("💬 Chat on WhatsApp:");
                                  sb.writeln(whatsappLink);
                                  sb.writeln();
                                }
                                sb.writeln("👉 Open Offer:");
                                sb.write(shareUrl);

                                final String text = sb.toString();

                                try {

                                  String mediaUrl = (offer.mediaUrl ?? "").trim();

                                  if (mediaUrl.isNotEmpty && !mediaUrl.startsWith("http")) {
                                    mediaUrl = "${AppUrl.baseurl}/$mediaUrl";
                                  }

                                  if (mediaUrl.isNotEmpty) {

                                    final response = await http.get(Uri.parse(mediaUrl));

                                    final tempDir = await getTemporaryDirectory();

                                    final file = File('${tempDir.path}/offer.jpg');

                                    await file.writeAsBytes(response.bodyBytes);

                                    await Share.shareXFiles(
                                      [XFile(file.path)],
                                      text: text,
                                    );

                                  } else {

                                    await Share.share(text);

                                  }

                                } catch (e) {

                                  print("SHARE ERROR => $e");

                                  await Share.share(text);
                                }
                              },
                            // onTap: () async {
                            //   final String shareUrl =
                            //       "https://server2.jobzinda.com/offering/${offer.id}";
                            //
                            //   final String text = """
                            //     🔥 Check this offer!
                            //
                            //      ${offer.bio ?? ''}
                            //
                            //      👉 Open Offer:
                            //             $shareUrl
                            //                         """;
                            //
                            //   try {
                            //     if (offer.mediaUrl != null &&
                            //         offer.mediaUrl!.isNotEmpty) {
                            //
                            //       final response =
                            //       await http.get(Uri.parse(offer.mediaUrl!));
                            //
                            //       final tempDir =
                            //       await getTemporaryDirectory();
                            //
                            //       final file =
                            //       File('${tempDir.path}/offer.jpg');
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
                            //     final newCount = await context
                            //         .read<OfferViewModel>()
                            //         .increaseShareCount(offer.id);
                            //
                            //     if (newCount != null && mounted) {
                            //       setState(() {
                            //         offer.shareCount = newCount;
                            //       });
                            //     }
                            //   } catch (e) {
                            //     debugPrint("Share error: $e");
                            //     await Share.share(text);
                            //   }
                            // },
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
class CustomVideoPlayer extends StatefulWidget {
  final String url;

  const CustomVideoPlayer({
    super.key,
    required this.url,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),

        IconButton(
          iconSize: 60,
          color: Colors.white,
          icon: Icon(
            _controller.value.isPlaying
                ? Icons.pause_circle
                : Icons.play_circle,
          ),
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
        ),
      ],
    );
  }
}
