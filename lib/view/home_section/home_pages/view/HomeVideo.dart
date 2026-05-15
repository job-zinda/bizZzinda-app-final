import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeVideoBanner extends StatefulWidget {
  const HomeVideoBanner({super.key});

  @override
  State<HomeVideoBanner> createState() => _HomeVideoBannerState();
}

class _HomeVideoBannerState extends State<HomeVideoBanner> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/videos/HomeVideo.mp4',
    );

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller
        ..setLooping(true)
        ..setVolume(1.0)
        ..play();

      _startHideTimer(); // 🔥 auto hide after play
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true; // pause → show icon
      } else {
        _controller.play();
        _startHideTimer(); // play → hide icon
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          _togglePlayPause();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : const Center(child: CircularProgressIndicator()),
            ),

            // ▶️ / ⏸ icon (auto hide)
            if (_showControls)
              Icon(
                _controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white.withOpacity(0.9),
                size: 60,
              ),
          ],
        ),
      ),
    );
  }
}
