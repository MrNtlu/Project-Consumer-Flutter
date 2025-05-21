import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:myanilist/services/cache_manager_service.dart';

class ImagePage extends StatelessWidget {
  final String _image;
  const ImagePage(this._image, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 2,
          child: CachedNetworkImage(
            imageUrl: _image,
            fit: BoxFit.contain,
            key: ValueKey(_image),
            cacheKey: _image,
            cacheManager: CustomCacheManager.instance,
            maxWidthDiskCache: 1080,
            maxHeightDiskCache: 1080,
          )
        ),
      ),
    );
  }
}
