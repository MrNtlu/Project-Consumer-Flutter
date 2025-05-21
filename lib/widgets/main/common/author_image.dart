import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';

class AuthorImage extends StatelessWidget {
  final String image;
  final double size;

  const AuthorImage(this.image, {this.size = 35, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size/2),
        child: Uri.tryParse(image) != null
        ? CachedNetworkImage(
          imageUrl: image,
          height: size,
          width: size,
          key: ValueKey<String>(image),
          cacheKey: image,
          cacheManager: CustomCacheManager(),
          maxHeightDiskCache: 300,
          maxWidthDiskCache: 300,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (_, __, ___) => const Padding(padding: EdgeInsets.all(3), child: CupertinoActivityIndicator()),
          errorListener: (_) {},
          errorWidget: (context, url, error) => Icon(
            Icons.person,
            size: size,
            color: CupertinoColors.activeBlue,
          ),
        )
        : Icon(
          Icons.person,
          size: size,
          color: CupertinoColors.activeBlue,
        ),
      ),
    );
  }
}