import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';
import 'package:watchlistfy/pages/main/review/review_list_page.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class ProfileReviewCell extends StatelessWidget {
  final ReviewWithContent data;
  final VoidCallback _fetchData;

  const ProfileReviewCell(this.data, this._fetchData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoTheme.of(context).brightness == Brightness.dark ? const Color(0xFF212121) : CupertinoColors.systemGrey3,
          width: 1.75,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (_) {
              return ReviewListPage(data.contentID, data.contentExternalID, data.contentExternalIntID, data.contentType, _fetchData);
            })
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50,
                  child: ContentCell(
                    data.content.imageURL,
                    data.content.titleEn,
                    cornerRadius: 6,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(data.content.titleEn, minFontSize: 15, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(DateTime.parse(data.createdAt).dateToHumanDate(), style: const TextStyle(color: CupertinoColors.systemGrey2, fontSize: 13))
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  data.star.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(width: 3),
                const Icon(
                  CupertinoIcons.star_fill,
                  color: CupertinoColors.systemYellow,
                  size: 15,
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AutoSizeText(
                data.review,
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CupertinoButton(
                  onPressed: () {},
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: const Icon(CupertinoIcons.heart, size: 20),
                ),
                Text(data.popularity.toString()),
              ],
            ),
          ],
        )
      ),
    );
  }
}