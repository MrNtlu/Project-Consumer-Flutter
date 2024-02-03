import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class CustomListEntryCell extends StatelessWidget {
  final ContentType? selectedContent;
  final BaseContent content;
  final bool doesContain;
  final VoidCallback onRemove;
  final VoidCallback? onAdd;

  const CustomListEntryCell(
    this.selectedContent,
    this.content,
    this.doesContain,
    this.onRemove,
    this.onAdd,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectedContent != null ? () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (_) {
            switch (selectedContent) {
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
          })
        );
      } : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: ContentCell(content.imageUrl, content.titleEn)
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.titleEn,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      content.titleOriginal,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey2
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(3),
                  onPressed: doesContain ? () {
                    onRemove();
                  } : (){},
                  child: Icon(Icons.remove_circle, color: doesContain ? CupertinoColors.destructiveRed : CupertinoColors.systemGrey2),
                ),
                if (onAdd != null)
                CupertinoButton(
                  padding: const EdgeInsets.all(3),
                  onPressed: doesContain ? (){} : () {
                    onAdd!(); 
                  },
                  child: Icon(Icons.add_circle, color: doesContain ? CupertinoColors.systemGrey2 : CupertinoColors.activeGreen),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}