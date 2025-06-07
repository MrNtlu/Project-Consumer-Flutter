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

    return ListView.builder(
        itemCount: seasons.length,
        scrollDirection: Axis.horizontal,
        itemExtent: 93,
        itemBuilder: (context, index) {
          final season = seasons[index];

          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(right: 3)
                : const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () {
                if (season.imageURL.isNotEmpty &
                    !season.imageURL.contains("null")) {
                  Navigator.of(context, rootNavigator: true)
                      .push(CupertinoPageRoute(builder: (_) {
                    return ImagePage(season.imageURL);
                  }));
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: cupertinoTheme.onBgColor.withValues(alpha: 0.75),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: 120,
                            child: ContentCell(
                              season.imageURL,
                              season.seasonNum.toString(),
                              cacheHeight: 265,
                              cacheWidth: 225,
                              forceRatio: true,
                            )),
                        const SizedBox(height: 8),
                        Text("Season ${season.seasonNum}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        if (season.airDate.isNotEmpty)
                          Text(DateTime.parse(season.airDate).dateToHumanDate(),
                              style: const TextStyle(fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        if (season.airDate.isEmpty)
                          const Text("Unknown", style: TextStyle(fontSize: 13)),
                        const SizedBox(height: 3),
                        Text("${season.episodeCount} eps.",
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
