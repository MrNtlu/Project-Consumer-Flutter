import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/recommendation/recommendation.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/providers/main/recommendation/recommendation_list_provider.dart';
import 'package:watchlistfy/providers/main/social/social_recommendation_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/common/author_info_row.dart';

class SocialRecommendationCell extends StatelessWidget {
  final RecommendationWithContent item;
  final bool isProfile;

  const SocialRecommendationCell(this.item,
      {this.isProfile = false, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecommendationListProvider()),
        ChangeNotifierProvider(create: (_) => SocialRecommendationProvider()),
      ],
      child:
          Consumer2<RecommendationListProvider, SocialRecommendationProvider>(
              builder: (context, provider, socialProvider, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CupertinoTheme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF212121)
                  : CupertinoColors.systemGrey3,
              width: 1.75,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) {
                            final contentType = ContentType.values
                                .where((element) =>
                                    item.contentType == element.request)
                                .first;
                            return DetailsPage(
                              id: item.contentID,
                              contentType: contentType,
                            );
                          },
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 125,
                      child: ContentCell(
                        forceRatio: true,
                        item.content.imageURL,
                        item.content.titleOriginal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.content.titleEn.isNotEmpty
                              ? item.content.titleEn
                              : item.content.titleOriginal,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.content.titleOriginal,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                builder: (_) {
                                  final contentType = ContentType.values
                                      .where((element) =>
                                          item.contentType == element.request)
                                      .first;
                                  return DetailsPage(
                                    id: item.recommendationID,
                                    contentType: contentType,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors().primaryColor,
                                width: 1.75,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 90,
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 75,
                                  child: ContentCell(
                                    forceRatio: true,
                                    item.recommendationContent.imageURL,
                                    item.recommendationContent.titleOriginal,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.recommendationContent.titleEn
                                                .isNotEmpty
                                            ? item.recommendationContent.titleEn
                                            : item.recommendationContent
                                                .titleOriginal,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.recommendationContent
                                            .titleOriginal,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.systemGrey2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "Recommended",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors().primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  !socialProvider.isLoading
                      ? CupertinoButton(
                          onPressed: isProfile
                              ? null
                              : () async {
                                  socialProvider.setLoading(true);

                                  provider
                                      .likeRecommendation(
                                          item.id, item.contentType)
                                      .then((value) {
                                    if (context.mounted) {
                                      socialProvider.setLoading(false);

                                      if (value.error != null) {
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (_) {
                                              return ErrorDialog(value.error ??
                                                  value.message ??
                                                  "Unknown error!");
                                            });
                                      }
                                    }
                                  });
                                },
                          minSize: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 6),
                          child: Icon(
                              item.isLiked
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              size: 20),
                        )
                      : const CupertinoActivityIndicator(),
                  Text(item.popularity.toString()),
                  if (item.isAuthor) const SizedBox(width: 6),
                  if (item.isAuthor)
                    CupertinoButton(
                      onPressed: () async {
                        showCupertinoDialog(
                            context: context,
                            builder: (_) {
                              return SureDialog("Do you want to delete it?",
                                  () {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (_) {
                                      return const LoadingDialog();
                                    });

                                provider
                                    .deleteRecommendation(item.id, item)
                                    .then((value) {
                                  if (context.mounted) {
                                    Navigator.pop(context);

                                    if (value.error != null) {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (_) {
                                            return ErrorDialog(value.error ??
                                                value.message ??
                                                "Unknown error!");
                                          });
                                    }
                                  }
                                });
                              });
                            });
                      },
                      minSize: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 6),
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
                                color: CupertinoColors.systemGrey2),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(CupertinoPageRoute(builder: (_) {
                                    return ProfileDisplayPage(
                                        item.author.username);
                                  }));
                                },
                                child: AuthorInfoRow(item.author, size: 28)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
