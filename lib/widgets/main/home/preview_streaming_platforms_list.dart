import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';

class PreviewStreamingPlatformsList extends StatelessWidget {
  final String region;

  const PreviewStreamingPlatformsList(this.region, {super.key});

  @override
  Widget build(BuildContext context) {
    final ContentProvider contentProvider =
        Provider.of<ContentProvider>(context);

    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contentProvider.selectedContent == ContentType.movie
            ? Constants.MovieStreamingPlatformList.length
            : (contentProvider.selectedContent == ContentType.tv
                ? Constants.TVStreamingPlatformList.length
                : Constants.AnimeStreamingPlatformList.length),
        itemBuilder: (context, index) {
          final isMovie = contentProvider.selectedContent == ContentType.movie;
          final isTV = contentProvider.selectedContent == ContentType.tv;

          if ((isMovie && Constants.MovieStreamingPlatformList.isEmpty) ||
              (isTV && Constants.TVStreamingPlatformList.isEmpty)) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text("Not available in your region."),
              ),
            );
          }

          final streamingPlatform = isMovie
              ? Constants.MovieStreamingPlatformList[index]
              : isTV
                  ? Constants.TVStreamingPlatformList[index]
                  : null;

          final animeStreamingPlatform = !(isMovie || isTV)
              ? Constants.AnimeStreamingPlatformList[index]
              : null;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) {
                    if (isMovie) {
                      return MovieDiscoverListPage(
                        streaming: streamingPlatform!.name,
                        streamingLogo: streamingPlatform.image,
                        region: region,
                      );
                    } else if (isTV) {
                      return TVDiscoverListPage(
                        streaming: streamingPlatform!.name,
                        streamingLogo: streamingPlatform.image,
                        region: region,
                      );
                    } else {
                      return AnimeDiscoverListPage(
                        streaming: animeStreamingPlatform!.name,
                        streamingLogo: animeStreamingPlatform.image,
                      );
                    }
                  },
                ),
              );
            },
            child: Padding(
              padding: index == 0
                  ? const EdgeInsets.only(left: 8, right: 4)
                  : const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 65,
                    width: 65,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: streamingPlatform?.image ??
                            animeStreamingPlatform!.image,
                        cacheKey: streamingPlatform?.image ??
                            animeStreamingPlatform!.image,
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.cover,
                        cacheManager: CustomCacheManager(),
                        maxHeightDiskCache: 250,
                        maxWidthDiskCache: 250,
                        errorListener: (_) {},
                        placeholder: (context, _) {
                          return ColoredBox(
                            color: CupertinoTheme.of(context).bgTextColor,
                            child: SizedBox(
                              height: 65,
                              width: 65,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: AutoSizeText(
                                    streamingPlatform?.name ??
                                        animeStreamingPlatform!.name,
                                    minFontSize: 13,
                                    style: TextStyle(
                                      color: CupertinoTheme.of(
                                        context,
                                      ).bgColor,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, _, __) {
                          return ColoredBox(
                            color: CupertinoTheme.of(context).bgTextColor,
                            child: SizedBox(
                              height: 65,
                              width: 65,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: AutoSizeText(
                                    streamingPlatform?.name ??
                                        animeStreamingPlatform!.name,
                                    minFontSize: 13,
                                    style: TextStyle(
                                      color: CupertinoTheme.of(context).bgColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
