import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/pages/main/review/review_create_page.dart';
import 'package:watchlistfy/pages/main/review/review_details_page.dart';
import 'package:watchlistfy/providers/main/review/review_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';

class ReviewListCell extends StatelessWidget {
  final Review item;
  final VoidCallback fetchData;
  final VoidCallback updateData;
  final ReviewListProvider provider;

  const ReviewListCell(this.item, this.fetchData, this.updateData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (_) {
                      return ProfileDisplayPage(item.author.username);
                    })
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Uri.tryParse(item.author.image) != null
                            ? CachedNetworkImage(
                              imageUrl: item.author.image,
                              height: 40,
                              width: 40,
                              cacheKey: item.author.image,
                              key: ValueKey<String>(item.author.image),
                              fit: BoxFit.cover,
                              cacheManager: CustomCacheManager(),
                              maxWidthDiskCache: 400,
                              maxHeightDiskCache: 400,
                              progressIndicatorBuilder: (_, __, ___) => const Padding(padding: EdgeInsets.all(3), child: CupertinoActivityIndicator()),
                              errorListener: (_) {},
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 40,
                                color: CupertinoColors.activeBlue,
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 40,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ),
                        if (item.author.isPremium)
                        Positioned(
                          bottom: -6,
                          right: -6,
                          child: Lottie.asset(
                            "assets/lottie/premium.json",
                            height: 30,
                            width: 30,
                            frameRate: const FrameRate(60)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.author.username,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          DateTime.parse(item.createdAt).dateToHumanDate(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey2
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                item.star.toString(),
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
          const SizedBox(height: 8),
          if (!item.isSpoiler)
          Text(
            item.review,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: CupertinoTheme.of(context).bgTextColor),
          ),
          if (item.isSpoiler)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                return ReviewDetailsPage(item, provider.voteReview);
              }));
            },
            child: const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  "This review contains spoiler! Tap to see it.",
                  style: TextStyle(color: CupertinoColors.systemRed, fontWeight: FontWeight.w500),
                ),
              ),
            ),
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
                    }
                  );

                  provider.voteReview(item.id).then((value) {
                    if (context.mounted) {
                      Navigator.pop(context);

                      if (value.error != null) {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) {
                            return ErrorDialog(value.error ?? value.message ?? "Unknown error!");
                          }
                        );
                      }
                    }
                  });
                },
                minSize: 0,
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                child: Icon(item.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 20),
              ),
              Text(item.popularity.toString()),
              if (item.isAuthor)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                          return ReviewCreatePage(
                            item.contentID, item.contentExternalID, item.contentExternalIntID,
                            item.contentType, fetchData, review: item, updateReviewData: updateData,
                          );
                        }));
                      },
                      minSize: 0,
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: const Icon(Icons.edit_rounded, size: 18),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) {
                            return SureDialog("Do you want to delete your review?", () {
                              showCupertinoDialog(
                                context: context,
                                builder: (_) {
                                  return const LoadingDialog();
                                }
                              );

                              provider.deleteReview(item.id, item).then((value) {
                                if (context.mounted) {
                                  fetchData();
                                  Navigator.pop(context);
                                }
                              });
                            });
                          }
                        );
                      },
                      minSize: 0,
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: const Icon(Icons.delete, size: 18),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                    return ReviewDetailsPage(item, provider.voteReview);
                  }));
                },
                child: const Text("Read More"),
              )
            ],
          )
        ],
      ),
    );
  }
}