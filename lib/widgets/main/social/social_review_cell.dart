import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';
import 'package:watchlistfy/pages/main/review/review_details_page.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/main/common/author_info_row.dart';

class SocialReviewCell extends StatelessWidget {
  final ReviewWithContent data;
  final Future<BaseMessageResponse> Function(String) likeReview;

  const SocialReviewCell(this.data, this.likeReview, {super.key});

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
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (_) {
              return ReviewDetailsPage(
                Review(
                  author: data.author,
                  star: data.star,
                  review: data.review,
                  popularity: data.popularity,
                  likes: data.likes,
                  isAuthor: data.isAuthor,
                  isSpoiler: data.isSpoiler,
                  isLiked: data.isLiked,
                  id: data.id,
                  userID: data.userID,
                  contentID: data.contentID,
                  contentExternalID: data.contentExternalID,
                  contentExternalIntID: data.contentExternalIntID,
                  contentType: data.contentType,
                  createdAt: data.createdAt,
                  updatedAt: data.updatedAt
                ),
                likeReview,
              );
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
                    forceRatio: true,
                    cacheHeight: 175,
                    cacheWidth: 125,
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
            if (data.isSpoiler)
            const Expanded(
              child: Center(
                child: Text(
                  "This review contains spoiler! Tap to see it.",
                  style: TextStyle(color: CupertinoColors.systemRed, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            if (!data.isSpoiler)
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: Icon(data.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 20),
                ),
                Text(data.popularity.toString()),
                const SizedBox(width: 16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AuthorInfoRow(data.author, size: 24)
                  )
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}