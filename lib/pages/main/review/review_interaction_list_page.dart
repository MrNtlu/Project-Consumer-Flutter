import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/pages/main/review/review_details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/review/review_interaction_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class ReviewInteractionListPage extends StatefulWidget {
  const ReviewInteractionListPage({super.key});

  @override
  State<ReviewInteractionListPage> createState() => ReviewInteractionListPageState();
}

class ReviewInteractionListPageState extends State<ReviewInteractionListPage> {
  ListState _state = ListState.init;
  String? _error;

  late final ReviewInteractionProvider _provider;
  late final AuthenticationProvider _authProvider;

  void _fetchData() {
    setState(() {
      _state = ListState.loading;
    });

    _provider.getLikedReviews().then((response) {
      _error = response.error;

      if (_state != ListState.disposed) {
        setState(() {
          _state = _error != null
            ? ListState.error
            : (
              response.data.isEmpty
                ? ListState.empty
                : ListState.done
            );
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _authProvider = Provider.of<AuthenticationProvider>(context);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = ReviewInteractionProvider();
    if (_state != ListState.init) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<ReviewInteractionProvider>(
        builder: (context, provider, child) {
      
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("💬 Liked Reviews"),
              trailing: CupertinoButton(
                onPressed: () {
                  // showCupertinoModalPopup(
                  //   context: context, 
                  //   builder: (context) {
                  //     return ReviewSortSheet(_fetchData, _provider);
                  //   }
                  // );
                },
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.sort_down, size: 28)
              ),
            ),
            child: _body(provider.items),
          );
        }
      ),
    );
  }

  Widget _body(List<Review> data) {
    switch (_state) {
      case ListState.done:
        return ListView.separated(
          separatorBuilder: (_, __) => const CustomDivider(height: 1, opacity: 0.3),
          itemCount: data.isEmpty ? 1 : data.length,
          itemBuilder: (context, index) {
            if (data.isEmpty) {
              return const EmptyView("assets/lottie/review.json", "You didn't like anything yet.");
            }

            final item = data[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      GestureDetector(
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
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Uri.tryParse(item.author.image) != null
                                ? CachedNetworkImage(
                                  imageUrl: item.author.image,
                                  key: ValueKey<String>(item.author.image),
                                  cacheKey: item.author.image,
                                  height: 40,
                                  width: 40,
                                  maxHeightDiskCache: 175,
                                  maxWidthDiskCache: 175,
                                  fit: BoxFit.cover,
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
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                        return ReviewDetailsPage(item, (String id) {
                          return _provider.likeReview(id, item);
                        });
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
                          if (_authProvider.isAuthenticated) {  
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return const LoadingDialog();
                              }
                            );

                            _provider.likeReview(item.id, item).then((value) {
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
                          } else {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return const ErrorDialog("You need to login to do this action.");
                              }
                            );
                          }
                        },
                        minSize: 0,
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        child: Icon(item.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 20),
                      ),
                      Text(item.popularity.toString()),
                      const Spacer(),
                      CupertinoButton(
                        minSize: 0,
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                            return ReviewDetailsPage(item, (String id) {
                              return _provider.likeReview(id, item);
                            });
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
        );
      case ListState.empty:
        return const EmptyView("assets/lottie/review.json", "You didn't like anything yet.");
      case ListState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_error ?? "Unknown error!"),
          ),
        );
      case ListState.loading:
        return const LoadingView("Fetching data");
      default:
       return const LoadingView("Loading");
    }
  }
}