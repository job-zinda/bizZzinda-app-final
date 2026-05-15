import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

/// Widget to display image or video based on URL/file extension
class AssignmentMediaWidget extends StatefulWidget {
  final String url;
  final double? height;
  final double? width;
  const AssignmentMediaWidget({Key? key, required this.url, this.height, this.width}) : super(key: key);

  @override
  State<AssignmentMediaWidget> createState() => _AssignmentMediaWidgetState();
}

class _AssignmentMediaWidgetState extends State<AssignmentMediaWidget> {
  VideoPlayerController? _controller;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.url.toLowerCase().endsWith('.mp4') || widget.url.toLowerCase().contains('video');
    if (_isVideo) {
      _controller = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo && _controller != null && _controller!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller!),
            if (!_controller!.value.isPlaying)
              IconButton(
                icon: const Icon(Icons.play_circle, size: 48, color: Colors.white),
                onPressed: () => setState(() => _controller!.play()),
              ),
          ],
        ),
      );
    } else if (!_isVideo) {
      return CachedNetworkImage(
        imageUrl: widget.url,
        height: widget.height,
        width: widget.width,
        fit: BoxFit.cover,
        placeholder: (ctx, _) => const Center(child: CircularProgressIndicator()),
        errorWidget: (ctx, _, __) => const Icon(Icons.broken_image),
      );
    }
    return const SizedBox.shrink();
  }
}
