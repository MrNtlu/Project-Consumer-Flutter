import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/common/name_url.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/game_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';

class GenreList extends StatelessWidget {
  const GenreList({super.key});

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);

    List<NameIcon> genreList;
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

    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (genreList.length / 2).ceil(),
        padding: const EdgeInsets.only(
          right: 6,
          left: 3,
        ),
        itemBuilder: (context, colIndex) {
          final first = genreList[colIndex * 2];
          final secondIndex = colIndex * 2 + 1;
          final second =
              secondIndex < genreList.length ? genreList[secondIndex] : null;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGenreChip(
                  context,
                  first,
                  genreList
                      .firstWhere((element) => element.name == first.name)
                      .icon,
                  contentProvider,
                ),
                const SizedBox(height: 12),
                if (second != null)
                  _buildGenreChip(
                    context,
                    second,
                    genreList
                        .firstWhere((element) => element.name == second.name)
                        .icon,
                    contentProvider,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenreChip(
    BuildContext context,
    NameIcon data,
    IconData icon,
    ContentProvider contentProvider,
  ) {
    final theme = CupertinoTheme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (_) {
            switch (contentProvider.selectedContent) {
              case ContentType.movie:
                return MovieDiscoverListPage(
                  genre: data.name != "Discover" ? data.name : null,
                );
              case ContentType.tv:
                return TVDiscoverListPage(
                  genre: data.name != "Discover" ? data.name : null,
                );
              case ContentType.anime:
                return AnimeDiscoverListPage(
                  genre: data.name != "Discover" ? data.name : null,
                );
              case ContentType.game:
                return GameDiscoverListPage(
                  genre: data.name != "Discover" ? data.name : null,
                );
            }
          },
        ));
      },
      child: SizedBox(
        width: 175,
        height: 45,
        child: Container(
          decoration: BoxDecoration(
            color: theme.profileButton,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColors().primaryColor,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: AutoSizeText(
                  data.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 11,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors().primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
