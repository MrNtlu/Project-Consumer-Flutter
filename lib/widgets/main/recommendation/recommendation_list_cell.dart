import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/recommendation/recommendation.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/providers/main/recommendation/recommendation_list_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/common/author_info_row.dart';

class RecommendationListCell extends StatelessWidget {
  final RecommendationWithContent item;
  final RecommendationListProvider _provider;

  const RecommendationListCell(this.item, this._provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (_) {
              final contentType = ContentType.values
                  .where((element) => item.contentType == element.request)
                  .first;
              return DetailsPage(
                id: item.recommendationID,
                contentType: contentType,
              );
            },
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 125,
                  child: ContentCell(
                    forceRatio: true,
                    item.recommendationContent.imageURL,
                    item.recommendationContent.titleOriginal,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.recommendationContent.titleEn.isNotEmpty
                            ? item.recommendationContent.titleEn
                            : item.recommendationContent.titleOriginal,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.recommendationContent.titleOriginal,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AutoSizeText(
                        item.reason ?? '',
                        minFontSize: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CupertinoButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (_) {
                        return const LoadingDialog();
                      },
                    );

                    _provider
                        .likeRecommendation(item.id, item.contentType)
                        .then(
                      (value) {
                        if (context.mounted) {
                          Navigator.pop(context);

                          if (value.error != null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return ErrorDialog(
                                  value.error ??
                                      value.message ??
                                      "Unknown error!",
                                );
                              },
                            );
                          }
                        }
                      },
                    );
                  },
                  minSize: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: Icon(
                      item.isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      size: 20),
                ),
                Text(item.popularity.toString()),
                if (item.isAuthor) const SizedBox(width: 6),
                if (item.isAuthor)
                  CupertinoButton(
                    onPressed: () async {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) {
                          return SureDialog(
                            "Do you want to delete it?",
                            () {
                              showCupertinoDialog(
                                context: context,
                                builder: (_) {
                                  return const LoadingDialog();
                                },
                              );

                              _provider
                                  .deleteRecommendation(item.id, item)
                                  .then(
                                (value) {
                                  if (context.mounted) {
                                    Navigator.pop(context);

                                    if (value.error != null) {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (_) {
                                          return ErrorDialog(value.error ??
                                              value.message ??
                                              "Unknown error!");
                                        },
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    minSize: 0,
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: const Icon(Icons.delete, size: 20),
                  ),
                const SizedBox(width: 24),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Recommended by ",
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).push(
                                CupertinoPageRoute(
                                  builder: (_) {
                                    return ProfileDisplayPage(
                                      item.author.username,
                                    );
                                  },
                                ),
                              );
                            },
                            child: AuthorInfoRow(
                              item.author,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
