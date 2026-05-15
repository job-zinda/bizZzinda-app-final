import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewScreen extends StatefulWidget {
  final String videoUrl;

  const VideoViewScreen({super.key, required this.videoUrl});

  @override
  _VideoViewScreenState createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    try {
      await videoPlayerController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: true,
      );

      // After initializing, update the UI
      setState(() {});
    } catch (e) {
      // Handle errors gracefully
      print("Error initializing video player: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing video: $e')),
      );
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Video Playback'),
      ),
      body: Center(
        child: videoPlayerController != null &&
                videoPlayerController!.value.isInitialized
            ? Chewie(controller: chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
