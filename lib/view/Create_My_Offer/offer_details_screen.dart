import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/utils/api_service.dart';
import 'package:biz_zinda/utils/api_url.dart';
import 'package:biz_zinda/view/Create_My_Offer/full_screen_vedeo.dart';
import 'package:biz_zinda/view/Create_My_Offer/offermodel.dart';
import 'package:biz_zinda/view/chat_bizzinda/chat_screen.dart';
import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OfferDetailScreen extends StatefulWidget {
  final String offerId;

  const OfferDetailScreen({
    super.key,
    required this.offerId,
  });

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  bool isLoading = true;
  bool isChatLoading = false;

  OfferingModel? offer;

  @override
  void initState() {
    super.initState();
    print("========== OFFER DETAIL SCREEN ==========");
    print("OFFER ID => ${widget.offerId}");
    fetchOfferDetails();
  }


  Future<void> fetchOfferDetails() async {
    try {
      debugPrint("SHARED OFFER ID => ${widget.offerId}");
      debugPrint(
        "SHARED OFFER URL => ${Api.sharedOfferingDetails}/${widget.offerId}",
      );

      final response = await dio.get(
        "${Api.sharedOfferingDetails}/${widget.offerId}",
      );

      debugPrint("SUCCESS => ${response.data}");

      final offeringData = response.data["data"]["offering"];

      setState(() {
        offer = OfferingModel.fromJson(offeringData);
        isLoading = false;
      });

      if (response.data["status"] == true) {
        final offeringData = response.data["data"]["offering"];

        setState(() {
          offer = OfferingModel.fromJson(offeringData);
          isLoading = false;
        });

        debugPrint("MODEL SUCCESS");
        debugPrint("OFFER BIO => ${offer?.bio}");
      } else {
        setState(() {
          isLoading = false;
        });

        debugPrint(
          "API MESSAGE => ${response.data["message"]}",
        );
      }
    } on DioException catch (e) {
      debugPrint("STATUS => ${e.response?.statusCode}");
      debugPrint("ERROR BODY => ${e.response?.data}");

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("MODEL ERROR => $e");

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String timeAgo(String date) {
    try {
      if (date.isEmpty) return "";

      final now = DateTime.now();
      final created = DateTime.parse(date).toLocal();
      final diff = now.difference(created);

      if (diff.inSeconds < 60) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hr ago";
      if (diff.inDays == 1) return "Yesterday";
      if (diff.inDays < 7) return "${diff.inDays} days ago";

      return "${created.day}/${created.month}/${created.year}";
    } catch (_) {
      return "";
    }
  }

  String getMediaUrl() {
    String url = offer?.mediaUrl ?? "";

    if (url.isNotEmpty && !url.startsWith("http")) {
      url = "${AppUrl.baseurl}/$url";
    }

    return url;
  }

  bool isVideo(String url) {
    final type = offer?.mediaType?.toLowerCase() ?? "";
    final lowerUrl = url.toLowerCase();

    return type.contains("video") ||
        lowerUrl.endsWith(".mp4") ||
        lowerUrl.endsWith(".mov") ||
        lowerUrl.endsWith(".mkv");
  }

  Widget buildMedia() {
    final mediaUrl = getMediaUrl();

    if (mediaUrl.isEmpty) {
      return Container(
        height: 330,
        width: double.infinity,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: Colors.grey,
        ),
      );
    }

    if (isVideo(mediaUrl)) {
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
        child: Container(
          width: double.infinity,
          height: 330,
          color: Colors.black,
          alignment: Alignment.center,
          child: const Icon(
            Icons.play_circle_fill,
            color: Colors.white,
            size: 70,
          ),
        ),
      );
    }

    return Image.network(
      mediaUrl,
      width: double.infinity,
      height: 330,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          height: 330,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 330,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(
            Icons.broken_image,
            size: 50,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  Future<void> startChat() async {
    if (isChatLoading) return;

    setState(() => isChatLoading = true);

    try {
      debugPrint("CHAT USER ID => ${offer?.userId}");
      debugPrint("CHAT USER NAME => ${offer?.userName}");
      debugPrint("OFFER ID => ${widget.offerId}");
      final userId = offer?.userId ?? "";

      if (userId.isEmpty) {
        EasyLoading.showError("User not found");
        return;
      }

      final response = await ApiService().post(
        "${AppUrl.baseurl}/api/v1/biz-chat/initiateChat",
        {
          "recipientUserId": userId,
          "offeringId": widget.offerId,
        },
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        final conversation =
        response.data["data"]?["conversation"] as Map<String, dynamic>?;

        final conversationId = conversation?["_id"]?.toString() ?? "";

        if (conversationId.isEmpty) {
          EasyLoading.showError("Conversation not found");
          return;
        }

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversationId: conversationId,
              shopName: offer?.userName ?? "Shop",
              offeringId: widget.offerId,
              offerImage: getMediaUrl(),
              offerBio: offer?.bio ?? "",
              userProfile: offer?.userProfile ?? "",
            ),
          ),
        );
      } else {
        EasyLoading.showError(
          response.data["message"] ?? "Unable to start chat",
        );
      }
    } catch (e) {
      debugPrint("CHAT ERROR => $e");
      EasyLoading.showError("Something went wrong");
    } finally {
      if (mounted) setState(() => isChatLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Offer Details"),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (offer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Offer Details")),
        body: const Center(
          child: Text(
            "Offer not found",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }

    final isOwnOffer = offer?.userId == LoggedInUser.id;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(title: const Text("Offer Details")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                final userId = offer?.userId ?? "";

                if (userId.isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtherUserProfileScreen(
                      userId: userId,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage: (offer?.userProfile ?? "").isNotEmpty
                    ? NetworkImage(offer!.userProfile)
                    : null,
                child: (offer?.userProfile ?? "").isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(
                (offer?.userName ?? "").isNotEmpty
                    ? offer!.userName!
                    : "No Name",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                timeAgo(offer?.createdAt ?? ""),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            buildMedia(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                offer?.bio ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 18,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${offer?.likesCount ?? 0} Likes",
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.share_outlined,
                    size: 18,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${offer?.shareCount ?? 0} Shares",
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.orange,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(
                    Icons.store,
                    color: Colors.orange,
                  ),
                  label: const Text(
                    "Visit My Store",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    final userId = offer?.userId ?? "";

                    if (userId.isEmpty) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtherUserProfileScreen(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),
            if (!isOwnOffer)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isChatLoading ? null : startChat,

                    icon: isChatLoading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                        : const Icon(Icons.chat_bubble_outline),
                    label: Text(
                      isChatLoading ? "Please wait..." : "Chat Now",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


// import 'package:biz_zinda/model/logged_in_user.dart';
// import 'package:biz_zinda/utils/api_service.dart';
// import 'package:biz_zinda/utils/api_url.dart';
// import 'package:biz_zinda/view/Create_My_Offer/full_screen_vedeo.dart';
// import 'package:biz_zinda/view/Create_My_Offer/offermodel.dart';
// import 'package:biz_zinda/view/chat_bizzinda/chat_screen.dart';
// import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
//
// class OfferDetailScreen extends StatefulWidget {
//   final String offerId;
//
//   const OfferDetailScreen({super.key, required this.offerId});
//
//   @override
//   State<OfferDetailScreen> createState() => _OfferDetailScreenState();
// }
//
// class _OfferDetailScreenState extends State<OfferDetailScreen> {
//   final Dio dio = Dio();
//
//   bool isLoading = true;
//   bool isChatLoading = false;
//
//   OfferingModel? offer;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchOfferDetails();
//   }
//
//   Future<void> fetchOfferDetails() async {
//     try {
//       final response = await dio.get(
//         "${Api.sharedOfferingDetails}/${widget.offerId}",
//       );
//
//       final data = response.data["data"]["offering"];
//
//       setState(() {
//         offer = OfferingModel.fromJson(data);
//         isLoading = false;
//       });
//     } catch (e) {
//       print("ERROR => $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   String timeAgo(String date) {
//     try {
//       final now = DateTime.now();
//       final created = DateTime.parse(date).toLocal();
//       final diff = now.difference(created);
//
//       if (diff.inSeconds < 60) return "Just now";
//       if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
//       if (diff.inHours < 24) return "${diff.inHours} hr ago";
//       if (diff.inDays == 1) return "Yesterday";
//       if (diff.inDays < 7) return "${diff.inDays} days ago";
//
//       return "${created.day}/${created.month}/${created.year}";
//     } catch (_) {
//       return "";
//     }
//   }
//
//   bool isVideo(String url) {
//     final type = offer?.mediaType?.toLowerCase() ?? "";
//     return type.contains("video") ||
//         url.endsWith(".mp4") ||
//         url.endsWith(".mov") ||
//         url.endsWith(".mkv");
//   }
//
//   Future<void> startChat() async {
//     if (isChatLoading) return;
//
//     setState(() => isChatLoading = true);
//
//     try {
//       final userId = offer?.userId ?? ""; // ✅ FIXED
//
//       if (userId.isEmpty) {
//         EasyLoading.showError("User not found");
//         return;
//       }
//
//       final response = await ApiService().post(
//         "${AppUrl.baseurl}/api/v1/biz-chat/initiateChat",
//         {
//           "recipientUserId": userId,
//           "offeringId": widget.offerId,
//         },
//       );
//
//       if (response.statusCode == 200 &&
//           response.data["status"] == true) {
//
//         final conversationId =
//             response.data["data"]["conversation"]["_id"] ?? "";
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ChatScreen(
//               conversationId: conversationId,
//               shopName: offer?.userName ?? "Shop",
//               offeringId: widget.offerId,
//               offerImage: offer?.mediaUrl ?? "",
//               offerBio: offer?.bio ?? "",
//               userProfile: offer?.userProfile ?? "",
//             ),
//           ),
//         );
//       } else {
//         EasyLoading.showError("Unable to start chat");
//       }
//     } catch (e) {
//       EasyLoading.showError("Something went wrong");
//     } finally {
//       if (mounted) setState(() => isChatLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     if (offer == null) {
//       return const Scaffold(
//         body: Center(child: Text("Offer not found")),
//       );
//     }
//
//     final isOwnOffer = offer?.userId == LoggedInUser.id;
//     final mediaUrl = offer?.mediaUrl ?? "";
//
//     return Scaffold(
//       backgroundColor: Colors.orange.shade50,
//       appBar: AppBar(title: const Text("Offer Details")),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//
//             ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => OtherUserProfileScreen(
//                       userId: offer?.userId ?? "",
//                     ),
//                   ),
//                 );
//               },
//               leading: CircleAvatar(
//                 backgroundImage: (offer?.userProfile ?? "").isNotEmpty
//                     ? NetworkImage(offer!.userProfile)
//                     : null,
//               ),
//               title: Text(offer?.userName ?? ""),
//               subtitle: Text(timeAgo(offer?.createdAt ?? "")),
//             ),
//
//             Container(
//               height: 330,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(mediaUrl),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(offer?.bio ?? ""),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   Text("${offer?.likesCount ?? 0} Likes"),
//                   const SizedBox(width: 20),
//                   Text("${offer?.shareCount ?? 0} Shares"),
//                 ],
//               ),
//             ),
//
//             if (!isOwnOffer)
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: ElevatedButton(
//                   onPressed: startChat,
//                   child: Text(isChatLoading ? "Loading..." : "Chat Now"),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:biz_zinda/model/logged_in_user.dart';
// // import 'package:biz_zinda/utils/api_service.dart';
// // import 'package:biz_zinda/utils/api_url.dart';
// // import 'package:biz_zinda/view/Create_My_Offer/full_screen_vedeo.dart';
// // import 'package:biz_zinda/view/chat_bizzinda/chat_screen.dart';
// // import 'package:biz_zinda/view/other_user_profile/view/other_user_profile_screen.dart';
// // import 'package:dio/dio.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_easyloading/flutter_easyloading.dart';
// // import 'package:biz_zinda/utils/api_url.dart';
// //
// // class OfferDetailScreen extends StatefulWidget {
// //   final String offerId;
// //
// //   const OfferDetailScreen({
// //     super.key,
// //     required this.offerId,
// //   });
// //
// //   @override
// //   State<OfferDetailScreen> createState() => _OfferDetailScreenState();
// // }
// //
// // class _OfferDetailScreenState extends State<OfferDetailScreen> {
// //   final Dio dio = Dio(
// //     BaseOptions(
// //       connectTimeout: const Duration(seconds: 30),
// //       receiveTimeout: const Duration(seconds: 30),
// //       sendTimeout: const Duration(seconds: 30),
// //     ),
// //   );
// //
// //   bool isLoading = true;
// //   bool isChatLoading = false;
// //   Map<String, dynamic>? offer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchOfferDetails();
// //   }
// //
// //   Future<void> fetchOfferDetails() async {
// //     try {
// //       print("SHARED OFFER ID => ${widget.offerId}");
// //
// //       final response = await dio.get(
// //         "${Api.sharedOfferingDetails}/${widget.offerId}",
// //       );
// //
// //       print("RESPONSE => ${response.data}");
// //
// //       final raw = response.data;
// //       final data = raw["data"];
// //
// //       if (!mounted) return;
// //
// //       setState(() {
// //         offer = (data is Map && data["offering"] != null)
// //             ? data["offering"]
// //             : (data is Map && data["offer"] != null)
// //             ? data["offer"]
// //             : data;
// //
// //         isLoading = false;
// //       });
// //
// //       print("FINAL OFFER => $offer");
// //
// //     } catch (e) {
// //       print("ERROR => $e");
// //
// //       if (!mounted) return;
// //
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   String getText(String key) {
// //     return offer?[key]?.toString() ?? "";
// //   }
// //
// //   String getMediaUrl() {
// //     String url = getText("mediaUrl");
// //
// //     if (url.isNotEmpty && !url.startsWith("http")) {
// //       url = "${AppUrl.baseurl}/$url";
// //     }
// //
// //     return url;
// //   }
// //
// //   bool isVideoUrl(String url) {
// //     final mediaType = getText("mediaType").toLowerCase();
// //     final lowerUrl = url.toLowerCase();
// //
// //     return mediaType.contains("video") ||
// //         lowerUrl.endsWith(".mp4") ||
// //         lowerUrl.endsWith(".mov") ||
// //         lowerUrl.endsWith(".mkv");
// //   }
// //
// //   String timeAgo(String? date) {
// //     if (date == null || date.isEmpty) return "";
// //
// //     try {
// //       final now = DateTime.now();
// //       final created = DateTime.parse(date).toLocal();
// //       final diff = now.difference(created);
// //
// //       if (diff.inSeconds < 60) return "Just now";
// //       if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
// //       if (diff.inHours < 24) return "${diff.inHours} hr ago";
// //       if (diff.inDays == 1) return "Yesterday";
// //       if (diff.inDays < 7) return "${diff.inDays} days ago";
// //
// //       return "${created.day}/${created.month}/${created.year}";
// //     } catch (_) {
// //       return "";
// //     }
// //   }
// //
// //   Widget buildMedia() {
// //     final mediaUrl = getMediaUrl();
// //
// //     if (mediaUrl.isEmpty) {
// //       return const SizedBox.shrink();
// //     }
// //
// //     if (isVideoUrl(mediaUrl)) {
// //       return GestureDetector(
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => FullScreenVideoPage(
// //                 videoUrl: mediaUrl,
// //               ),
// //             ),
// //           );
// //         },
// //         child: Container(
// //           width: double.infinity,
// //           height: 330,
// //           color: Colors.black,
// //           alignment: Alignment.center,
// //           child: const Icon(
// //             Icons.play_circle_fill,
// //             color: Colors.white,
// //             size: 70,
// //           ),
// //         ),
// //       );
// //     }
// //
// //     return Image.network(
// //       mediaUrl,
// //       width: double.infinity,
// //       height: 330,
// //       fit: BoxFit.cover,
// //       loadingBuilder: (context, child, progress) {
// //         if (progress == null) return child;
// //
// //         return Container(
// //           height: 330,
// //           alignment: Alignment.center,
// //           child: const CircularProgressIndicator(),
// //         );
// //       },
// //       errorBuilder: (context, error, stackTrace) {
// //         return Container(
// //           height: 330,
// //           color: Colors.grey.shade300,
// //           alignment: Alignment.center,
// //           child: const Icon(
// //             Icons.broken_image,
// //             size: 50,
// //             color: Colors.grey,
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Future<void> startChat() async {
// //     if (isChatLoading) return;
// //
// //     setState(() {
// //       isChatLoading = true;
// //     });
// //
// //     try {
// //       final userId = getText("userId");
// //
// //       if (userId.isEmpty) {
// //         EasyLoading.showError("User not found");
// //         return;
// //       }
// //
// //       final response = await ApiService().post(
// //         "${AppUrl.baseurl}/api/v1/biz-chat/initiateChat",
// //         {
// //           "recipientUserId": userId,
// //           "offeringId": widget.offerId,
// //         },
// //       );
// //
// //       if (response.statusCode == 200 && response.data["status"] == true) {
// //         final conversation = response.data["data"]["conversation"];
// //         final conversationId = conversation["_id"]?.toString() ?? "";
// //
// //         if (conversationId.isEmpty) {
// //           EasyLoading.showError("Conversation not found");
// //           return;
// //         }
// //
// //         if (!mounted) return;
// //
// //         Navigator.of(context, rootNavigator: true).push(
// //           MaterialPageRoute(
// //             builder: (_) => ChatScreen(
// //               conversationId: conversationId,
// //               shopName: getText("userName").isNotEmpty
// //                   ? getText("userName")
// //                   : "Shop",
// //               offerImage: getMediaUrl(),
// //               offerBio: getText("bio"),
// //               userProfile: getText("userProfile"),
// //             ),
// //           ),
// //         );
// //       } else {
// //         EasyLoading.showError(
// //           response.data["message"] ?? "Unable to start chat",
// //         );
// //       }
// //     } catch (e) {
// //       debugPrint("CHAT ERROR => $e");
// //       EasyLoading.showError("Something went wrong");
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           isChatLoading = false;
// //         });
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (isLoading) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: const Text("Offer Details"),
// //         ),
// //         body: const Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //     }
// //
// //     if (offer == null) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: const Text("Offer Details"),
// //         ),
// //         body: const Center(
// //           child: Text(
// //             "Offer not found",
// //             style: TextStyle(color: Colors.black),
// //           ),
// //         ),
// //       );
// //     }
// //
// //     final isOwnOffer = getText("userId") == LoggedInUser.id;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.orange.shade50,
// //       appBar: AppBar(
// //         backgroundColor: Colors.orange,
// //         iconTheme: const IconThemeData(color: Colors.black),
// //         title: const Text(
// //           "Offer Details",
// //           style: TextStyle(color: Colors.black),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             ListTile(
// //               onTap: () {
// //                 final userId = getText("userId");
// //
// //                 if (userId.isEmpty) return;
// //
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (_) => OtherUserProfileScreen(
// //                       userId: userId,
// //                     ),
// //                   ),
// //                 );
// //               },
// //               leading: CircleAvatar(
// //                 backgroundImage: getText("userProfile").isNotEmpty
// //                     ? NetworkImage(getText("userProfile"))
// //                     : null,
// //                 child: getText("userProfile").isEmpty
// //                     ? const Icon(Icons.person)
// //                     : null,
// //               ),
// //               title: Text(
// //                 getText("userName").isNotEmpty
// //                     ? getText("userName")
// //                     : "No Name",
// //                 style: const TextStyle(
// //                   color: Colors.black,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               subtitle: Text(
// //                 timeAgo(getText("createdAt")),
// //                 style: const TextStyle(
// //                   color: Colors.grey,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //             ),
// //             buildMedia(),
// //             Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: Text(
// //                 getText("bio"),
// //                 style: const TextStyle(
// //                   color: Colors.black,
// //                   fontSize: 16,
// //                   height: 1.4,
// //                 ),
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               child: Row(
// //                 children: [
// //                   const Icon(
// //                     Icons.thumb_up_alt_outlined,
// //                     size: 18,
// //                     color: Colors.orange,
// //                   ),
// //                   const SizedBox(width: 5),
// //                   Text(
// //                     "${getText("likesCount").isEmpty ? "0" : getText("likesCount")} Likes",
// //                     style: const TextStyle(color: Colors.black),
// //                   ),
// //                   const SizedBox(width: 20),
// //                   const Icon(
// //                     Icons.share_outlined,
// //                     size: 18,
// //                     color: Colors.orange,
// //                   ),
// //                   const SizedBox(width: 5),
// //                   Text(
// //                     "${getText("shareCount").isEmpty ? "0" : getText("shareCount")} Shares",
// //                     style: const TextStyle(color: Colors.black),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             if (!isOwnOffer)
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: SizedBox(
// //                   width: double.infinity,
// //                   height: 48,
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.orange,
// //                       foregroundColor: Colors.black,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                     ),
// //                     onPressed: isChatLoading ? null : startChat,
// //                     icon: isChatLoading
// //                         ? const SizedBox(
// //                       width: 18,
// //                       height: 18,
// //                       child: CircularProgressIndicator(
// //                         strokeWidth: 2,
// //                         color: Colors.black,
// //                       ),
// //                     )
// //                         : const Icon(Icons.chat_bubble_outline),
// //                     label: Text(
// //                       isChatLoading ? "Please wait..." : "Chat Now",
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             const SizedBox(height: 24),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }