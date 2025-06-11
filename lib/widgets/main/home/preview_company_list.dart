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

    final isGameOrAnime = contentProvider.selectedContent == ContentType.game ||
        contentProvider.selectedContent == ContentType.anime;
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
      height: 120,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final company = list[index];

          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(
                    left: 8,
                    right: 6,
                  )
                : const EdgeInsets.symmetric(horizontal: 6),
            child: _buildCompanyCard(
              context,
              company,
              cupertinoTheme,
              contentProvider,
              isGameOrAnime,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompanyCard(
    BuildContext context,
    BackendRequestMapperWithImage company,
    CupertinoThemeData theme,
    ContentProvider contentProvider,
    bool isGameOrAnime,
  ) {
    return GestureDetector(
      onTap: () => _navigateToDiscoverPage(context, contentProvider, company),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 120,
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
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ColoredBox(
                    color: CupertinoColors.white,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _buildCompanyImage(
                        company,
                        theme,
                        isGameOrAnime,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 38,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Center(
                child: AutoSizeText(
                  company.name.isNotEmpty ? company.name : "Unknown",
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

  Widget _buildCompanyImage(
    BackendRequestMapperWithImage company,
    CupertinoThemeData theme,
    bool isGameOrAnime,
  ) {
    return CachedNetworkImage(
      imageUrl: company.image,
      cacheKey: company.image,
      key: ValueKey<String>(company.image),
      cacheManager: CustomCacheManager(),
      maxHeightDiskCache: 200,
      maxWidthDiskCache: 250,
      fit: isGameOrAnime ? BoxFit.cover : BoxFit.contain,
      errorWidget: (context, _, __) => _buildErrorWidget(company, theme),
      progressIndicatorBuilder: (_, __, ___) => _buildLoadingWidget(theme),
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutDuration: const Duration(milliseconds: 0),
    );
  }

  Widget _buildErrorWidget(
    BackendRequestMapperWithImage company,
    CupertinoThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bgTextColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: AutoSizeText(
          company.name,
          minFontSize: 10,
          maxFontSize: 14,
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
    BackendRequestMapperWithImage company,
  ) {
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
      builder: (_) {
        switch (contentProvider.selectedContent) {
          case ContentType.movie:
            return MovieDiscoverListPage(productionCompanies: company.name);
          case ContentType.tv:
            return TVDiscoverListPage(productionCompanies: company.name);
          case ContentType.anime:
            return AnimeDiscoverListPage(studios: company.name);
          case ContentType.game:
            return GameDiscoverListPage(publisher: company.name);
        }
      },
    ));
  }
}
