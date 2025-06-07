import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/backend_request_mapper.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/game_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';

class PreviewCompanyList extends StatelessWidget {
  const PreviewCompanyList({super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    final ContentProvider contentProvider =
        Provider.of<ContentProvider>(context);

    final isMovieOrTVSeries =
        contentProvider.selectedContent == ContentType.movie ||
            contentProvider.selectedContent == ContentType.tv;

    final List<BackendRequestMapperWithImage> list;

    switch (contentProvider.selectedContent) {
      case ContentType.tv:
        list = Constants.TVPopularStudiosList;
        break;
      case ContentType.anime:
        list = Constants.AnimePopularStudiosList;
        break;
      case ContentType.game:
        list = Constants.GamePopularPublishersList;
        break;
      default:
        list = Constants.MoviePopularStudiosList;
        break;
    }

    return SizedBox(
        height: 75,
        child: ListView.builder(
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final company = list[index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(CupertinoPageRoute(
                    builder: (_) {
                      switch (contentProvider.selectedContent) {
                        case ContentType.movie:
                          return MovieDiscoverListPage(
                            productionCompanies: company.name,
                          );
                        case ContentType.tv:
                          return TVDiscoverListPage(
                            productionCompanies: company.name,
                          );
                        case ContentType.anime:
                          return AnimeDiscoverListPage(studios: company.name);
                        case ContentType.game:
                          return GameDiscoverListPage(publisher: company.name);
                      }
                    },
                  ));
                },
                child: Padding(
                  padding: index == 0
                      ? const EdgeInsets.only(
                          left: 8,
                          right: 4,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                  child: SizedBox(
                    width: isMovieOrTVSeries ? 150 : 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ColoredBox(
                        color: CupertinoColors.white,
                        child: CachedNetworkImage(
                          imageUrl: company.image,
                          cacheKey: company.image,
                          key: ValueKey<String>(company.image),
                          cacheManager: CustomCacheManager(),
                          maxHeightDiskCache: 175,
                          maxWidthDiskCache: isMovieOrTVSeries ? 300 : 150,
                          errorWidget: (context, _, __) {
                            return ColoredBox(
                              color: cupertinoTheme.bgTextColor,
                              child: SizedBox(
                                height: 65,
                                width: 65,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Center(
                                    child: AutoSizeText(
                                      company.name,
                                      minFontSize: 13,
                                      style: TextStyle(
                                        color: cupertinoTheme.bgColor,
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
                          progressIndicatorBuilder: (_, __, ___) => SizedBox(
                            height: 75,
                            width: isMovieOrTVSeries ? 150 : 75,
                            child: Shimmer.fromColors(
                              baseColor: CupertinoColors.systemGrey,
                              highlightColor: CupertinoColors.systemGrey3,
                              child: const ColoredBox(
                                  color: CupertinoColors.systemGrey2),
                            ),
                          ),
                          fadeInDuration: const Duration(milliseconds: 0),
                          fadeOutDuration: const Duration(milliseconds: 0),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
