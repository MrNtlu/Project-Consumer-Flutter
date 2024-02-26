import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class ContentListCell extends StatelessWidget {
  final ContentType _contentType;
  final BaseContent content;

  const ContentListCell(this._contentType, {required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    final String extraInfoText;
    switch (_contentType) {
      case ContentType.movie:
        extraInfoText = content.extraInfo?.toLength() ?? content.extraInfo2 ?? '';
        break;
      case ContentType.tv:
        extraInfoText = "${content.extraInfo ?? "?"} seas. ${content.extraInfo2 ?? "?"} eps.";
        break;
      case ContentType.anime:
        extraInfoText = "${content.extraInfo ?? "?"} eps.";
        break;
      default:
        extraInfoText = content.extraInfo != null
          ? "Metacritic ${content.extraInfo}"
          : content.extraInfo2 != null
            ? DateTime.parse(content.extraInfo2!).dateToHumanDate()
            : "?";
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (_) {
            switch (_contentType) {
              case ContentType.movie:
                return MovieDetailsPage(content.id);
              case ContentType.tv:
                return TVDetailsPage(content.id);
              case ContentType.anime:
                return AnimeDetailsPage(content.id);
              case ContentType.game:
                return GameDetailsPage(content.id);
              default:
                return MovieDetailsPage(content.id);
            }
          }, maintainState: false)
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
        child: Row(
          children: [
            SizedBox(
              height: 135,
              child: ContentCell(
                content.imageUrl,
                content.titleEn, cornerRadius: 8,
                forceRatio: true,
                cacheHeight: 350,
                cacheWidth: _contentType != ContentType.game ? 275 : 500,
              )
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      content.titleEn.isNotEmpty ? content.titleEn : content.titleOriginal,
                      minFontSize: 16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      wrapWords: true,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 3),
                    AutoSizeText(
                      content.titleOriginal,
                      minFontSize: 12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.systemGrey2
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      content.description.removeAllHtmlTags(),
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          content.score?.toStringAsFixed(2) ?? "0",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        FaIcon(
                          _contentType != ContentType.game
                          ? FontAwesomeIcons.ticket
                          : FontAwesomeIcons.gamepad,
                        size: 14),
                        const SizedBox(width: 6),
                        Text(
                          extraInfoText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}