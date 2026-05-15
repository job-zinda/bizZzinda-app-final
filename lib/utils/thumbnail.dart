//   import 'dart:developer';

// import 'package:get_thumbnail_video/index.dart';
// import 'package:get_thumbnail_video/video_thumbnail.dart';
// import 'package:path_provider/path_provider.dart';

// Future<XFile?> generateThumbnail({required String url}) async {
//   XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
//   video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
//   thumbnailPath: (await getTemporaryDirectory()).path,
//   imageFormat: ImageFormat.PNG,
//   maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//   quality: 75,
// );
// log('generate $thumbnailFile');
//     return thumbnailFile;
//   }