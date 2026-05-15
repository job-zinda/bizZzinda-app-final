import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A wrapper around [CachedNetworkImage] that safely handles empty or invalid URLs
/// and falls back to a local placeholder asset.  Optionally you can specify
/// [width], [height] and [fit].
class SafeCachedNetworkImage extends StatelessWidget {
  const SafeCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.placeholderAsset,
    this.width,
    this.height,
    this.fit,
    this.memCacheWidth = 800,
    this.memCacheHeight = 800,
  }) : super(key: key);

  final String? imageUrl;
  final String? placeholderAsset;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final int memCacheWidth;
  final int memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl ?? '';
    final isValid = url.startsWith('http://') || url.startsWith('https://');
    if (!isValid || url.isEmpty) {
      return Image.asset(
        placeholderAsset ?? 'assets/images/no_image.jpg',
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (_, __, ___) {
          // Fallback to a bundled no_image asset if the specified placeholder is missing.
          return Image.asset(
            'assets/images/no_image.jpg',
            width: width,
            height: height,
            fit: fit ?? BoxFit.cover,
          );
        },
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, _) => SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
      ),
      errorWidget: (context, _, __) => Image.asset(
        placeholderAsset ?? 'assets/images/no_image.jpg',
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/no_image.jpg',
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }
}

/// Convenience helper for getting an [ImageProvider] that is safe.
ImageProvider safeImageProvider(String? url, {String placeholderAsset = 'assets/images/no_image.jpg'}) {
  if (url == null || url.isEmpty || (!url.startsWith('http://') && !url.startsWith('https://'))) {
    return AssetImage(placeholderAsset);
  }
  return CachedNetworkImageProvider(url);
}
