import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';

class ReviewDetailsPage extends StatefulWidget {
  final Review item;
  final Future<BaseMessageResponse> Function(String) likeReview;

  const ReviewDetailsPage(this.item, this.likeReview, {super.key});

  @override
  State<ReviewDetailsPage> createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  bool isInit = false;

  late final AuthenticationProvider authProvider;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      authProvider = Provider.of<AuthenticationProvider>(context);

      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("💬 ${widget.item.author.username}'s Review"),
      ),
      child: SafeArea(
        child: Padding(
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
                          CupertinoPageRoute(
                              builder: (_) {
                                return ProfileDisplayPage(
                                    widget.item.author.username);
                              },
                              maintainState:
                                  NavigationTracker().shouldMaintainState()));
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
                                child: Uri.tryParse(widget.item.author.image) !=
                                        null
                                    ? CachedNetworkImage(
                                        imageUrl: widget.item.author.image,
                                        key: ValueKey<String>(
                                            widget.item.author.image),
                                        cacheKey: widget.item.author.image,
                                        height: 40,
                                        width: 40,
                                        cacheManager: CustomCacheManager(),
                                        maxHeightDiskCache: 175,
                                        maxWidthDiskCache: 175,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (_, __, ___) => const Padding(
                                                padding: EdgeInsets.all(3),
                                                child:
                                                    CupertinoActivityIndicator()),
                                        errorListener: (_) {},
                                        errorWidget: (context, url, error) =>
                                            const Icon(
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
                            if (widget.item.author.isPremium)
                              Positioned(
                                bottom: -6,
                                right: -6,
                                child: Lottie.asset(
                                    "assets/lottie/premium.json",
                                    height: 30,
                                    width: 30,
                                    frameRate: const FrameRate(60)),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.author.username,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateTime.parse(widget.item.createdAt)
                                  .dateToHumanDate(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.systemGrey2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.item.star.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.item.review,
                    style: TextStyle(
                        fontSize: 15,
                        color: CupertinoTheme.of(context).bgTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CupertinoButton(
                    onPressed: () async {
                      if (authProvider.isAuthenticated) {
                        showCupertinoDialog(
                            context: context,
                            builder: (_) {
                              return const LoadingDialog();
                            });

                        widget.likeReview(widget.item.id).then(
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
                              } else {
                                setState(() {
                                  widget.item.isLiked = !widget.item.isLiked;
                                  widget.item.popularity =
                                      widget.item.popularity +
                                          (widget.item.isLiked ? 1 : -1);
                                });
                              }
                            }
                          },
                        );
                      } else {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => const ErrorDialog(
                              "You need to login to do this action."),
                        );
                      }
                    },
                    minSize: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 6,
                    ),
                    child: Icon(
                      widget.item.isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      size: 20,
                    ),
                  ),
                  Text(widget.item.popularity.toString()),
                  const Spacer(),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) {
                            final contentType = ContentType.values
                                .where((element) =>
                                    element.request == widget.item.contentType)
                                .first;
                            return DetailsPage(
                              id: widget.item.contentID,
                              contentType: contentType,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Go To ${ContentType.values.where((element) => element.request == widget.item.contentType).first.value}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
