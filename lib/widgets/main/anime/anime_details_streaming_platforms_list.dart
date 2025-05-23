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
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                return AnimeDiscoverListPage(
                  streaming: item.name,
                  streamingLogo: 'https://img.logo.dev/${item.url}?token=pk_C1fcC0OuSJS-HB9jCN0LIg',
                );
              }, maintainState: NavigationTracker().shouldMaintainState()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 100,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: 'https://img.logo.dev/${item.url}?token=pk_C1fcC0OuSJS-HB9jCN0LIg',
                        fit: BoxFit.cover,
                        key: ValueKey<String>(item.name),
                        cacheKey: item.name,
                        height: 64,
                        width: 64,
                        cacheManager: CustomCacheManager(),
                        maxHeightDiskCache: 190,
                        maxWidthDiskCache: 190,
                        errorWidget: (context, _, __) {
                          return ColoredBox(
                            color: CupertinoTheme.of(context).bgTextColor,
                            child: SizedBox(
                              height: 64,
                              width: 64,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: AutoSizeText(
                                    item.name,
                                    minFontSize: 13,
                                    style: TextStyle(
                                      color: CupertinoTheme.of(context).bgColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                            ),
                          );
                        },
                        placeholder: (context, _) {
                          return ColoredBox(
                            color: CupertinoTheme.of(context).bgTextColor,
                            child: SizedBox(
                              height: 64,
                              width: 64,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: AutoSizeText(
                                    item.name,
                                    minFontSize: 13,
                                    style: TextStyle(color: CupertinoTheme.of(context).bgColor, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    AutoSizeText(
                      item.name,
                      maxLines: 1,
                      maxFontSize: 16,
                      minFontSize: 13,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}