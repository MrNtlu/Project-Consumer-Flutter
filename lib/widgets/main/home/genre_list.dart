import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/common/name_url.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/game_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/constants.dart';

class GenreList extends StatelessWidget {
  const GenreList({super.key});

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);

    var genreSize = switch (contentProvider.selectedContent) {
      ContentType.movie => Constants.MovieGenreList.length,
      ContentType.anime => Constants.AnimeGenreList.length,
      ContentType.tv => Constants.TVGenreList.length,
      ContentType.game => Constants.GameGenreList.length,
    };

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        height: 75,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: genreSize,
          itemExtent: 135,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            List<NameUrl> genreList;

            switch (contentProvider.selectedContent) {
              case ContentType.movie:
                genreList = Constants.MovieGenreList;
                break;
              case ContentType.tv:
                genreList = Constants.TVGenreList;
                break;
              case ContentType.anime:
                genreList = Constants.AnimeGenreList;
                break;
              case ContentType.game:
                genreList = Constants.GameGenreList;
                break;
            }

            final data = genreList[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (_) {
                      switch (contentProvider.selectedContent) {
                        case ContentType.movie:
                          return MovieDiscoverListPage(genre: data.name != "Discover" ? data.name : null);
                        case ContentType.tv:
                          return TVDiscoverListPage(genre: data.name != "Discover" ? data.name : null);
                        case ContentType.anime:
                          return AnimeDiscoverListPage(genre: data.name != "Discover" ? data.name : null);
                        case ContentType.game:
                          return GameDiscoverListPage(genre: data.name != "Discover" ? data.name : null);
                      }
                    })
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: data.url,
                        cacheKey: data.url,
                        key: ValueKey<String>(data.url),
                        cacheManager: CustomCacheManager(),
                        maxHeightDiskCache: 250,
                        maxWidthDiskCache: contentProvider.selectedContent == ContentType.game ? 300 : 200,
                        errorListener: (_) {},
                        progressIndicatorBuilder: (_, __, ___) => const SizedBox(
                          height: 75,
                          width: 129,
                          child: ColoredBox(
                            color: CupertinoColors.systemGrey2
                          ),
                        ),
                        fadeInDuration: const Duration(milliseconds: 0),
                        fadeOutDuration: const Duration(milliseconds: 0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColoredBox(
                            color: CupertinoColors.black.withOpacity(0.75),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                              child: Text(
                                data.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}