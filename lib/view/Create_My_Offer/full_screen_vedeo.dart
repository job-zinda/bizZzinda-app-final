import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPage({
    super.key,
    required this.videoUrl,
  });

  @override
  State<FullScreenVideoPage> createState() =>
      _FullScreenVideoPageState();
}

class _FullScreenVideoPageState
    extends State<FullScreenVideoPage> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
    VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: !_controller.value.isInitialized
            ? const CircularProgressIndicator()
            : GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}