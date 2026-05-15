// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:jora_customer/Settings/until/PColors.dart';
// import 'package:jora_customer/Settings/until/PSvgs.dart';
// import 'package:jora_customer/main.dart';
// import 'package:jora_customer/model/myStory_model.dart';
// import 'package:jora_customer/model/story_model.dart';
// import 'package:jora_customer/view_model/story_view_model.dart';
// import 'package:provider/provider.dart';
// import 'package:story_view/story_view.dart';

// class DisplayStoryPage extends StatelessWidget {
//   final StoryController controller = StoryController();
//   TextEditingController _commentController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<StoryViewModel>(
//         builder: (context, value, child) => Stack(
//           children: [
//             StoryView(
//               storyItems: value.isMyProfile
//                   ? _buildMyStoryItems(value.myStoryModel)
//                   : _buildStoryItems(value.storyModel),
//               onStoryShow: (storyItem, index) {
//                 if (value.isMyProfile) {
//                   final mediaId = value.myStoryModel.media![index].sId;
//                   print("media id------}");
//                   // value.fetchStoryViews(
//                   //     mediaId: mediaId!,
//                   //     storyId: value.myStoryModel.sId.toString());
//                 }
//               },
//               inline: true,
//               onVerticalSwipeComplete: (direction) {
//                 if (direction == Direction.down) {
//                   Navigator.pop(context);
//                 }
//               },
//               onComplete: () {
//                 print("Story completed!");

//                 // Dispose of the controller
//                 controller.dispose();

//                 // Navigate back to the previous page
//                 if (Navigator.canPop(context)) {
//                   Navigator.pop(context);
//                 }
//               },
//               controller: controller,
//               repeat: false,
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                   color: Colors.black.withOpacity(0.8),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8.0, vertical: 8.0),
//                   child: value.isMyProfile
//                       ? storyViewCountWidget()
//                       : addComment()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   addComment() {
//     return Row(
//       children: [
//         Expanded(
//           // child: CustomTextFeild(hintText: "Add a comment", filColor: PColors.whiteOff,borderRadius: 25,),
//           child: TextField(
//             controller: _commentController,
//             style: TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//                 hintText: "Add a comment...",
//                 hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
//                 border: InputBorder.none,
//                 fillColor: Colors.white,
//                 enabledBorder:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
//                 focusedBorder:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
//                 filled: true),
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.send, color: Colors.white),
//           onPressed: () {
//             // _addComment();
//           },
//         ),
//       ],
//     );
//   }

//   storyViewCountWidget() {
//     return Consumer<StoryViewModel>(
//       builder: (context, value, child) => Container(
//         width: 150,
//         height: 50,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             color: PColors.whiteOff.withOpacity(0.3)),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SvgPicture.asset(PSvgs.eye),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 "${value.storyCount.toString()} Views",
//                 style: TextStyle(
//                     color: PColors.white, fontWeight: FontWeight.w500),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<StoryItem> _buildStoryItems(StoryModel story) {
//     return story.media!.map<StoryItem>((story) {
//       switch (story.mediaType) {
//         // case "text":
//         //   return StoryItem.text(
//         //     title: story.bio,
//         //     backgroundColor:  Colors.black,
//         //     textStyle: TextStyle(
//         //       fontSize: 25,
//         //       color: Colors.white,
//         //     ),
//         //   );
//         case "image":
//           return StoryItem.pageImage(
//             url: story.content.toString(),
//             // caption: story["caption"] ?? "",
//             controller: controller,
//             // caption: Text(story.b)
//           );
//         case "video":
//           return StoryItem.pageVideo(
//             story.content.toString(),
//             // caption: story["caption"] ?? "",
//             controller: controller,
//           );
//         default:
//           return StoryItem.text(
//             title: "Invalid story type",
//             backgroundColor: Colors.grey,
//             textStyle: TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//             ),
//           );
//       }
//     }).toList();
//   }

//   List<StoryItem> _buildMyStoryItems(MyStoryModel storyModel) {
//     return storyModel.media!.map<StoryItem>((story) {
//       print("hhhhhh");
//       // navigatorKey.currentContext!.read<StoryViewModel>().fetchStoryViews(
//       //     mediaId: story.sId.toString(), storyId: storyModel.sId.toString());
//       switch (story.mediaType) {
//         // case "text":
//         //   return StoryItem.text(
//         //     title: story.bio,
//         //     backgroundColor:  Colors.black,
//         //     textStyle: TextStyle(
//         //       fontSize: 25,
//         //       color: Colors.white,
//         //     ),
//         //   );
//         case "image":
//           return StoryItem.pageImage(
//             url: story.content.toString(),
//             key: Key("123"),
//             // caption: Text(" Views: 21"),
//             controller: controller,
//           );
//         case "video":
//           return StoryItem.pageVideo(
//             story.content.toString(),
//             // caption: story["caption"] ?? "",
//             controller: controller,
//           );
//         default:
//           return StoryItem.text(
//             title: "Invalid story type",
//             backgroundColor: Colors.grey,
//             textStyle: TextStyle(
//               fontSize: 20,
//               color: Colors.white,
//             ),
//           );
//       }
//     }).toList();
//   }
// }
