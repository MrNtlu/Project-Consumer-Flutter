import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/tv/tv_details_season.dart';
import 'package:watchlistfy/pages/main/image_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class TVSeasonList extends StatelessWidget {
  final List<TVDetailsSeason> seasons;
  const TVSeasonList(this.seasons, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return SizedBox(
      height: 240,
      child: ListView.builder(
        itemCount: seasons.length,
        scrollDirection: Axis.horizontal,
        itemExtent: 140,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == seasons.length - 1 ? 0 : 8,
            ),
            child: _buildSeasonCard(context, season, index, cupertinoTheme),
          );
        },
      ),
    );
  }

  Widget _buildSeasonCard(
    BuildContext context,
    TVDetailsSeason season,
    int index,
    CupertinoThemeData theme,
  ) {
    return GestureDetector(
      onTap: () => _navigateToImage(context, season, index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: theme.onBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.bgTextColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Hero(
                  tag: 'tv_season_${season.seasonNum}_$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ContentCell(
                      season.imageURL.replaceFirst("original", "w300"),
                      season.seasonNum.toString(),
                      cacheHeight: 265,
                      cacheWidth: 225,
                      forceRatio: true,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: _buildSeasonInfo(season, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonInfo(TVDetailsSeason season, CupertinoThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Season ${season.seasonNum}",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: theme.bgTextColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        if (season.airDate.isNotEmpty)
          Text(
            DateTime.parse(season.airDate).dateToHumanDate(),
            style: TextStyle(
              fontSize: 12,
              color: theme.bgTextColor.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (season.airDate.isEmpty)
          Text(
            "Unknown",
            style: TextStyle(
              fontSize: 12,
              color: theme.bgTextColor.withValues(alpha: 0.7),
            ),
          ),
        const SizedBox(height: 1),
        Text(
          "${season.episodeCount} eps.",
          style: TextStyle(
            fontSize: 12,
            color: theme.bgTextColor.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _navigateToImage(
      BuildContext context, TVDetailsSeason season, int index) {
    if (season.imageURL.isNotEmpty && !season.imageURL.contains("null")) {
      Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
          builder: (_) => ImagePage(
            season.imageURL,
            heroTag: 'tv_season_${season.seasonNum}_$index',
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }
}
