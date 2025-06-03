import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';

class ContentCell extends StatelessWidget {
  final String url;
  final String title;
  final double cornerRadius;
  final bool forceRatio;
  final int? cacheWidth;
  final int? cacheHeight;

  const ContentCell(
    this.url,
    this.title, {
    this.cornerRadius = 12,
    this.forceRatio = false,
    this.cacheWidth,
    this.cacheHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const defaultBorderRadius = BorderRadius.all(Radius.circular(12));
    final selectedContent = context.select<ContentProvider, ContentType>(
      (provider) => provider.selectedContent,
    );
    final theme = CupertinoTheme.of(context);
    final aspect =
        forceRatio || selectedContent != ContentType.game ? 2 / 3 : 16 / 9;

    return AspectRatio(
      aspectRatio: aspect,
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: (!forceRatio && selectedContent == ContentType.game)
            ? Stack(
                children: [
                  _buildImage(
                    selectedContent: selectedContent,
                    theme: theme,
                    aspect: aspect,
                    borderRadius: defaultBorderRadius,
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ColoredBox(
                        color: CupertinoColors.black,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: Opacity(
                        opacity: 0.7,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : _buildImage(
                selectedContent: selectedContent,
                theme: theme,
                aspect: aspect,
                borderRadius: defaultBorderRadius,
              ),
      ),
    );
  }

  Widget _buildImage({
    required ContentType selectedContent,
    required CupertinoThemeData theme,
    required double aspect,
    required BorderRadius borderRadius,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      key: ValueKey<String>(url),
      cacheKey: url,
      cacheManager: CustomCacheManager(),
      maxWidthDiskCache: cacheWidth,
      maxHeightDiskCache: cacheHeight,
      filterQuality: FilterQuality.low,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (_, __, ___) {
        return AspectRatio(
          aspectRatio: aspect,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Shimmer.fromColors(
              baseColor: CupertinoColors.systemGrey,
              highlightColor: CupertinoColors.systemGrey3,
              child: const ColoredBox(
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
        );
      },
      errorListener: (_) {},
      errorWidget: (context, url, error) {
        if (kDebugMode) {
          print("Image error for $url --> $error");
        }

        return ColoredBox(
          color: theme.bgTextColor,
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.primaryContrastingColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
