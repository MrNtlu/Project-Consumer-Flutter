import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/pages/main/discover/game_discover_list_page.dart';
import 'package:watchlistfy/pages/main/image_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/game/game_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_carousel_slider.dart';
import 'package:watchlistfy/widgets/main/common/details_genre_list.dart';
import 'package:watchlistfy/widgets/main/common/details_main_info.dart';
import 'package:watchlistfy/widgets/main/common/details_navigation_bar.dart';
import 'package:watchlistfy/widgets/main/common/details_recommendation_list.dart';
import 'package:watchlistfy/widgets/main/common/details_review_summary.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';
import 'package:watchlistfy/widgets/main/game/game_details_info_column.dart';
import 'package:watchlistfy/widgets/main/game/game_details_play_list_sheet.dart';

class GameDetailsPage extends StatefulWidget {
  final String id;

  const GameDetailsPage(this.id, {super.key});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  DetailState _state = DetailState.init;

  late final GameDetailsProvider _provider;
  late final AuthenticationProvider _authProvider;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getGameDetails(widget.id).then((response) {
      _error = response.error;

      if (_state != DetailState.disposed) {
        setState(() {
          _state = response.error != null
            ? DetailState.error
            : (
              response.data != null
                ? DetailState.view
                : DetailState.error
            );
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _authProvider = Provider.of<AuthenticationProvider>(context);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = GameDetailsProvider();
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<GameDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                DetailsNavigationBar(
                  _provider.item?.title.isNotEmpty == true ? _provider.item!.title : _provider.item?.titleOriginal ?? '',
                  "game",
                  _provider.item == null,
                  _provider.item?.userList == null,
                  _provider.item?.consumeLater == null,
                  provider.isUserListLoading,
                  provider.isLoading,
                  isAuthenticated: _authProvider.isAuthenticated,
                  onBookmarkTap: () {
                    if (!provider.isLoading && _authProvider.isAuthenticated) {
                      final item = provider.item;

                      if (item != null && item.consumeLater != null) {
                        provider.deleteConsumeLaterObject(IDBody(item.consumeLater!.id)).then((response) {
                          if (response.error != null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) => ErrorDialog(response.error!),
                            );
                          }
                        });
                      } else if (item != null) {
                        provider.createConsumeLaterObject(
                          ConsumeLaterBody(item.id, item.rawgId.toString(), "game")
                        ).then((response) {
                          if (response.error != null) {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) => ErrorDialog(response.error!),
                            );
                          }
                        });
                      }
                    } else if (!_authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => const UnauthorizedDialog()
                      );
                    }
                  },
                  onListTap: () {
                    if (!provider.isUserListLoading && _authProvider.isAuthenticated) {
                      final item = provider.item;

                      if (item != null && item.userList != null) {
                        final status = Constants.UserListStatus.firstWhere((element) => element.request == item.userList!.status).name;
                        final score = item.userList!.score ?? 'Not Scored';
                        final hoursPlayed = item.userList!.watchedEpisodes ?? "?";
                        final timesFinished = item.userList!.timesFinished;

                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return UserListViewSheet(
                              _provider.item!.id,
                              _provider.item!.title,
                              "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)\n📺 $hoursPlayed hrs.",
                              _provider.item!.userList!,
                              externalIntID: _provider.item!.rawgId,
                              contentType: ContentType.game,
                              gameProvider: provider,
                            );
                          }
                        );
                      } else if (item != null) {
                        showCupertinoModalPopup(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return GameDetailsPlayListSheet(
                              _provider,
                              _provider.item!.id,
                              _provider.item!.rawgId,
                            );
                          }
                        );
                      }
                    } else if (!_authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => const UnauthorizedDialog()
                      );
                    }
                  }
                ),
                _body(provider)
              ],
            )
          );
        },
      ),
    );
  }

  Widget _body(GameDetailsProvider provider) {
    switch (_state) {
      case DetailState.view:
        final item = provider.item!;

        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            DetailsMainInfo(
                              item.rawgRating.toStringAsFixed(2),
                              item.tba ? "TBA" : (
                                item.releaseDate != null ? DateTime.parse(item.releaseDate!).dateToHumanDate() : ''
                              ),
                              "game",
                              item.id
                            ),
                            const SizedBox(height: 32),
                            GameDetailsInfoColumn(
                              item.title != item.titleOriginal,
                              item.titleOriginal,
                              item.ageRating,
                              item.metacriticScore
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            return ImagePage(item.imageUrl);
                          })
                        );
                      },
                      child: SizedBox(
                        height: 125,
                        child: ContentCell(item.imageUrl, item.title, forceRatio: true, cornerRadius: 8)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                const CustomDivider(height: 0.75, opacity: 0.35),
                const DetailsTitle("Description"),
                ExpandableText(
                  item.description.removeAllHtmlTags(),
                  maxLines: 3,
                  expandText: "Read More",
                  collapseText: "Read Less",
                  linkColor: CupertinoColors.systemBlue,
                  style: const TextStyle(fontSize: 16),
                  linkStyle: const TextStyle(fontSize: 14),
                ),
                const DetailsTitle("Genres"),
                DetailsGenreList(item.genres, (genre) {
                  return GameDiscoverListPage(genre: genre);
                }),
                if (item.developers.isNotEmpty)
                const DetailsTitle("Developers"),
                if (item.developers.isNotEmpty)
                Text(
                  item.developers.isNotEmpty ? item.developers.join(" • ") : "",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (item.publishers.isNotEmpty)
                const DetailsTitle("Publishers"),
                if (item.publishers.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.publishers.length,
                    itemBuilder: (context, index) {
                      final publisher = item.publishers[index];

                      return CupertinoChip(
                        isSelected: false,
                        onSelected: (_) {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(builder: (_) {
                              return GameDiscoverListPage(publisher: Uri.encodeQueryComponent(publisher));
                            })
                          );
                        },
                        label: publisher,
                      );
                    },
                  ),
                ),
                const DetailsTitle("Platforms"),
                DetailsGenreList(item.platforms, (platform) {
                  return GameDiscoverListPage(platform: platform);
                }),
                if(item.relatedGames.isNotEmpty)
                const DetailsTitle("Related Games"),
                if(item.relatedGames.isNotEmpty)
                SizedBox(
                  height: 150,
                  child: DetailsRecommendationList(
                    item.relatedGames.length,
                    (index) {
                      return item.relatedGames[index].imageURL;
                    },
                    (index) {
                      return item.relatedGames[index].title;
                    },
                    (index) {
                      return GameDetailsPage(item.relatedGames[index].rawgId.toString());
                    }
                  ),
                ),
                DetailsReviewSummary(
                  item.title.isNotEmpty ? item.title : item.titleOriginal,
                  item.reviewSummary, item.id,
                  null, item.rawgId,
                  ContentType.game.request, _fetchData,
                ),
                if (item.screenshots.isNotEmpty)
                const DetailsTitle("Screenshots"),
                if (item.screenshots.isNotEmpty)
                DetailsCarouselSlider(item.screenshots),
                //TODO Store id map
                const SizedBox(height: 32)
              ],
            ),
          ),
        );
      case DetailState.error:
        return SliverFillRemaining(child: ErrorView(_error ?? "Unknown error", _fetchData));
      case DetailState.loading:
        return const SliverFillRemaining(child: LoadingView("Loading"));
      default:
        return const SliverFillRemaining(child: LoadingView("Loading"));
    }
  }
}
