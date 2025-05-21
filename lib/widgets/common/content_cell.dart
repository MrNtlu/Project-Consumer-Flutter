import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:myanilist/services/cache_manager_service.dart';

class ContentCell extends StatelessWidget {
  final String url;
  final String title;
  final double cornerRadius;
  final bool forceRatio;
  final int? cacheWidth;
  final int? cacheHeight;

  const ContentCell(this.url, this.title, {this.cornerRadius = 12, this.forceRatio = false, this.cacheWidth, this.cacheHeight, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context);

    return AspectRatio(
      aspectRatio: forceRatio || provider.selectedContent != ContentType.game ? 2/3 : 16/9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: !forceRatio && provider.selectedContent == ContentType.game
        ? Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _image(provider.selectedContent)
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ColoredBox(
                  color: CupertinoColors.black.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.white),
                    ),
                  )
                ),
              ),
            )
          ]
        )
        : _image(provider.selectedContent),
      ),
    );
  }

  Widget _image(ContentType selectedContent) {
    return CachedNetworkImage(
      imageUrl: url,
      key: ValueKey<String>(url + title),
      cacheKey: url + title,
      cacheManager: CustomCacheManager.instance,
      maxWidthDiskCache: cacheWidth,
      maxHeightDiskCache: cacheHeight,
      filterQuality: FilterQuality.low,
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutDuration: const Duration(milliseconds: 0),
      fit: BoxFit.cover,
      progressIndicatorBuilder: (_, __, ___) => AspectRatio(
        aspectRatio: forceRatio || selectedContent != ContentType.game ? 2/3 : 16/9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Shimmer.fromColors(
            baseColor: CupertinoColors.systemGrey, 
            highlightColor: CupertinoColors.systemGrey3,
            child: const ColoredBox(color: CupertinoColors.systemGrey,)
          )
        ),
      ),
      errorListener: (_) {},
      errorWidget: (context, url, error) => ColoredBox(
        color: CupertinoTheme.of(context).bgTextColor,
        child: AspectRatio(
          aspectRatio: selectedContent != ContentType.game ? 2/3 : 16/9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoTheme.of(context).bgColor,
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
