import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:watchlistfy/models/main/anime/anime_details_name_url.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/navigation_provider.dart';

class AnimeDetailsStreamingPlatformsList extends StatelessWidget {
  final List<AnimeNameUrl> data;

  const AnimeDetailsStreamingPlatformsList(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == data.length - 1 ? 0 : 8,
            ),
            child: _buildPlatformCard(context, item, cupertinoTheme),
          );
        },
      ),
    );
  }

  Widget _buildPlatformCard(
    BuildContext context,
    AnimeNameUrl item,
    CupertinoThemeData theme,
  ) {
    final logoBaseUrl = item.url
        .replaceAll(RegExp(r'^(?:https?:\/\/)?(?:www\.)?'), '')
        .split('/')[0];

    final streamingLogoUrl =
        'https://img.logo.dev/$logoBaseUrl?token=pk_C1fcC0OuSJS-HB9jCN0LIg';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _navigateToDiscover(context, item, streamingLogoUrl),
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: theme.onBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.bgTextColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPlatformImage(item, streamingLogoUrl, theme),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AutoSizeText(
                item.name,
                maxLines: 1,
                maxFontSize: 14,
                minFontSize: 12,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.bgTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformImage(
    AnimeNameUrl item,
    String streamingLogoUrl,
    CupertinoThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: streamingLogoUrl,
          fit: BoxFit.cover,
          key: ValueKey<String>(item.name),
          cacheKey: item.name,
          height: 64,
          width: 64,
          cacheManager: CustomCacheManager(),
          maxHeightDiskCache: 190,
          maxWidthDiskCache: 190,
          errorWidget: (context, _, __) => _buildFallbackWidget(item, theme),
          placeholder: (context, _) => _buildFallbackWidget(item, theme),
        ),
      ),
    );
  }

  Widget _buildFallbackWidget(AnimeNameUrl item, CupertinoThemeData theme) {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: theme.bgTextColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: AutoSizeText(
          item.name,
          minFontSize: 10,
          maxFontSize: 13,
          style: TextStyle(
            color: theme.bgTextColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }

  void _navigateToDiscover(
    BuildContext context,
    AnimeNameUrl item,
    String streamingLogoUrl,
  ) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) => AnimeDiscoverListPage(
          streaming: item.name,
          streamingLogo: streamingLogoUrl,
        ),
        maintainState: NavigationTracker().shouldMaintainState(),
      ),
    );
  }
}
