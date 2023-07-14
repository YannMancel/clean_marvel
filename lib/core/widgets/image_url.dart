import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageUrl extends StatelessWidget {
  const ImageUrl(
    String imageUrl, {
    super.key,
    BaseCacheManager? cacheManager,
  })  : _imageUrl = imageUrl,
        _cacheManager = cacheManager;

  final String _imageUrl;
  final BaseCacheManager? _cacheManager;

  @visibleForTesting
  static const imageUrlPropertyName = 'imageUrl';

  @visibleForTesting
  static const cacheManagerPropertyName = 'cacheManager';

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        StringProperty(imageUrlPropertyName, _imageUrl),
      )
      ..add(
        DiagnosticsProperty<BaseCacheManager?>(
          cacheManagerPropertyName,
          _cacheManager,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: _cacheManager,
      imageUrl: _imageUrl,
      imageBuilder: (_, imageProvider) => DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (_, __) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      errorWidget: (_, __, ___) => const Center(
        child: Icon(Icons.error),
      ),
    );
  }
}
