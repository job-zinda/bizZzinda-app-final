import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../utils/api_url.dart';

/// Widget to display admin document inline (image/video preview) or as a download button for other file types.
class AdminDocWidget extends StatefulWidget {
  final String url;
  final double? height;
  final double? width;
  final String? caption;
  final bool allowDownload;
  final bool allowShare;
  const AdminDocWidget({Key? key, required this.url, this.height, this.width, this.caption, this.allowDownload = true, this.allowShare = true}) : super(key: key);

  @override
  State<AdminDocWidget> createState() => _AdminDocWidgetState();
}

class _AdminDocWidgetState extends State<AdminDocWidget> {
  VideoPlayerController? _controller;
  bool _isVideo = false;
  bool _isImage = false;

  @override
  void initState() {
    super.initState();
    final url = widget.url.toLowerCase();
    _isVideo = url.endsWith('.mp4') || url.contains('video');
    _isImage = url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.png') || url.endsWith('.gif');
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
    if (_isImage) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: widget.url,
            height: widget.height,
            width: widget.width,
            fit: BoxFit.cover,
            placeholder: (ctx, _) => const Center(child: CircularProgressIndicator()),
            errorWidget: (ctx, _, __) => const Icon(Icons.broken_image),
          ),
          _actionButtons(context),
          if ((widget.caption ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(widget.caption!),
            ),
        ],
      );
    } else if (_isVideo && _controller != null && _controller!.value.isInitialized) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
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
          ),
          _actionButtons(context),
          if ((widget.caption ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(widget.caption!),
            ),
        ],
      );
    } else {
      // For other file types, show only download button
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _actionButtons(context),
          if ((widget.caption ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(widget.caption!),
            ),
        ],
      );
    }
  }

  Widget _actionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.allowDownload)
            OutlinedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Download'),
              onPressed: () async {
                final s3Url = widget.url;
                if (await canLaunchUrl(Uri.parse(s3Url))) {
                  await launchUrl(Uri.parse(s3Url), mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch download URL')),
                  );
                }
              },
            ),
          if (widget.allowDownload && widget.allowShare)
            const SizedBox(width: 8),
          if (widget.allowShare)
            OutlinedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              onPressed: () async {
                try {
                  final uri = Uri.parse(widget.url);
                  // Download the file to a temp directory for sharing
                  final resp = await http.get(uri);
                  if (resp.statusCode == 200) {
                    final dir = await getTemporaryDirectory();
                    final fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'shared_file';
                    final filePath = '${dir.path}/$fileName';
                    final file = File(filePath);
                    await file.writeAsBytes(resp.bodyBytes);
                    await Share.shareXFiles([XFile(filePath)], text: widget.caption ?? '');
                  } else {
                    // Fallback to sharing the URL with caption if download fails
                    await Share.share('${widget.caption != null && widget.caption!.isNotEmpty ? widget.caption! + '\n' : ''}${widget.url}');
                  }
                } catch (e) {
                  // Fallback to sharing the URL with caption on any error
                  await Share.share('${widget.caption != null && widget.caption!.isNotEmpty ? widget.caption! + '\n' : ''}${widget.url}');
                }
              },
            ),
        ],
      ),
    );
  }
}
