import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class ProfileLegendCell extends StatelessWidget {
  final String url;
  final String title;
  final int? timesFinished;
  final int? hoursPlayed;
  final bool isGame;

  const ProfileLegendCell(
    this.url,
    this.title, {
    this.timesFinished,
    this.hoursPlayed,
    this.isGame = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
                height: double.infinity,
                child: ContentCell(
                  url.replaceFirst(
                    "original",
                    "w400",
                  ),
                  title,
                  forceRatio: true,
                  cacheHeight: 350,
                  cacheWidth: isGame ? 450 : 270,
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ColoredBox(
                  color: CupertinoColors.black.withValues(
                    alpha: 0.8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hoursPlayed == null
                              ? CupertinoIcons.flag_fill
                              : CupertinoIcons.time_solid,
                          size: 16,
                          color: AppColors().primaryColor,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            hoursPlayed?.toString() ?? timesFinished.toString(),
                            maxLines: 1,
                            minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                        Text(
                          hoursPlayed == null ? " times" : " hrs",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: CupertinoColors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
