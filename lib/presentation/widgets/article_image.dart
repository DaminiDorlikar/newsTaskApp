import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Displays a remote article image with a consistent loading/error placeholder.
/// The URL is supplied by the article model, which assigns an illustrative
/// category image when DummyJSON has no real image for a post.
class ArticleImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final BorderRadius? borderRadius;

  const ArticleImage({
    super.key,
    required this.imageUrl,
    this.height = 190,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.newspaper_rounded,
        size: 54,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

    final image = imageUrl.trim().isEmpty
        ? placeholder
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              height: height,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (_, __, ___) => placeholder,
          );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
