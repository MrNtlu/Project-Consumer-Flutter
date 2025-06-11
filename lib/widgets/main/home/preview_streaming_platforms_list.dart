import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';

class PreviewStreamingPlatformsList extends StatelessWidget {
  final String region;

  const PreviewStreamingPlatformsList(
    this.region, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final ContentProvider contentProvider =
        Provider.of<ContentProvider>(context);

    final isMovie = contentProvider.selectedContent == ContentType.movie;
    final isTV = contentProvider.selectedContent == ContentType.tv;
    final itemCount = isMovie
        ? Constants.MovieStreamingPlatformList.length
        : (isTV
            ? Constants.TVStreamingPlatformList.length
            : Constants.AnimeStreamingPlatformList.length);

    if ((isMovie && Constants.MovieStreamingPlatformList.isEmpty) ||
        (isTV && Constants.TVStreamingPlatformList.isEmpty)) {
      return SizedBox(
        height: 110,
        width: width,
        child: Center(
          child: Text(
            "Not available in your region.",
            style: TextStyle(
              color: cupertinoTheme.textTheme.textStyle.color,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          final streamingPlatform = isMovie
              ? Constants.MovieStreamingPlatformList[index]
              : isTV
                  ? Constants.TVStreamingPlatformList[index]
                  : null;

          final animeStreamingPlatform = !(isMovie || isTV)
              ? Constants.AnimeStreamingPlatformList[index]
              : null;

          final platform = streamingPlatform ?? animeStreamingPlatform!;

          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(left: 8, right: 6)
                : const EdgeInsets.symmetric(horizontal: 6),
            child: _buildStreamingCard(
              context,
              platform,
              cupertinoTheme,
              contentProvider,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStreamingCard(
    BuildContext context,
    dynamic platform,
    CupertinoThemeData theme,
    ContentProvider contentProvider,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _navigateToDiscoverPage(context, contentProvider, platform),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.barBackgroundColor,
              theme.barBackgroundColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColoredBox(
                    color: CupertinoColors.white,
                    child: _buildPlatformImage(platform, theme),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Center(
                child: AutoSizeText(
                  platform.name.isNotEmpty ? platform.name : "Unknown",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.textStyle.color,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  minFontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformImage(
    dynamic platform,
    CupertinoThemeData theme,
  ) {
    return CachedNetworkImage(
      imageUrl: platform.image,
      cacheKey: platform.image,
      filterQuality: FilterQuality.low,
      fit: BoxFit.cover,
      cacheManager: CustomCacheManager(),
      maxHeightDiskCache: 200,
      maxWidthDiskCache: 200,
      errorListener: (_) {},
      placeholder: (context, _) => _buildLoadingWidget(theme),
      errorWidget: (context, _, __) => _buildErrorWidget(platform, theme),
    );
  }

  Widget _buildErrorWidget(dynamic platform, CupertinoThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bgTextColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: AutoSizeText(
          platform.name,
          minFontSize: 8,
          maxFontSize: 12,
          style: TextStyle(
            color: theme.bgTextColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(CupertinoThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Shimmer.fromColors(
        baseColor: theme.bgTextColor.withValues(alpha: 0.1),
        highlightColor: theme.bgTextColor.withValues(alpha: 0.05),
        child: Container(
          color: theme.bgTextColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  void _navigateToDiscoverPage(
    BuildContext context,
    ContentProvider contentProvider,
    dynamic platform,
  ) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) {
          final isMovie = contentProvider.selectedContent == ContentType.movie;
          final isTV = contentProvider.selectedContent == ContentType.tv;

          if (isMovie) {
            return MovieDiscoverListPage(
              streaming: platform.name,
              streamingLogo: platform.image,
              region: region,
            );
          } else if (isTV) {
            return TVDiscoverListPage(
              streaming: platform.name,
              streamingLogo: platform.image,
              region: region,
            );
          } else {
            return AnimeDiscoverListPage(
              streaming: platform.name,
              streamingLogo: platform.image,
            );
          }
        },
      ),
    );
  }
}
