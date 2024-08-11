import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/anime/anime_details_relation.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/image_page.dart';
import 'package:watchlistfy/pages/main/recommendation/recommendation_content_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/anime/anime_details_provider.dart';
import 'package:watchlistfy/static/ads_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/interstitial_ad_handler.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/anime/anime_details_info_column.dart';
import 'package:watchlistfy/widgets/main/anime/anime_details_streaming_platforms_list.dart';
import 'package:watchlistfy/widgets/main/anime/anime_watch_list_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_button_row.dart';
import 'package:watchlistfy/widgets/main/common/details_character_list.dart';
import 'package:watchlistfy/widgets/main/common/details_genre_list.dart';
import 'package:watchlistfy/widgets/main/common/details_main_info.dart';
import 'package:watchlistfy/widgets/main/common/details_navigation_bar.dart';
import 'package:watchlistfy/widgets/main/common/details_recommendation_list.dart';
import 'package:watchlistfy/widgets/main/common/details_review_summary.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';
import "package:collection/collection.dart";

class AnimeDetailsPage extends StatefulWidget {
  final String id;

  const AnimeDetailsPage(this.id, {super.key});

  @override
  State<AnimeDetailsPage> createState() => _AnimeDetailsPageState();
}

class _AnimeDetailsPageState extends State<AnimeDetailsPage> {
  DetailState _state = DetailState.init;

  late final AnimeDetailsProvider _provider;
  late final AuthenticationProvider _authProvider;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getAnimeDetails(widget.id).then((response) {
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

      final shouldShowAds = _authProvider.basicUserInfo == null || _authProvider.basicUserInfo?.isPremium == false;
      if (AdsTracker().shouldShowAds() && shouldShowAds) {
        InterstitialAdHandler().showAds();
      }
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = AnimeDetailsProvider();
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
      child: Consumer<AnimeDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                DetailsNavigationBar(
                  _state == DetailState.view ? (
                    _provider.item?.title.isNotEmpty == true ? _provider.item!.title : _provider.item?.titleOriginal ?? _provider.item?.titleJP ?? ''
                  ) : "",
                  "anime",
                  _provider.item == null,
                  _provider.item?.userList == null,
                  _provider.item?.consumeLater == null,
                  provider.isUserListLoading,
                  provider.isLoading,
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
                          ConsumeLaterBody(item.id, item.malID.toString(), "anime")
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
                        final episodes = item.userList!.watchedEpisodes ?? "?";
                        final timesFinished = item.userList!.timesFinished;

                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return UserListViewSheet(
                              _provider.item!.id,
                              _provider.item!.title,
                              "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)\n📺 $episodes eps",
                              _provider.item!.userList!,
                              externalIntID: _provider.item!.malID,
                              contentType: ContentType.anime,
                              animeProvider: provider,
                            );
                          }
                        );
                      } else if (item != null) {
                        showCupertinoModalPopup(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AnimeWatchListSheet(
                              _provider,
                              _provider.item!.id,
                              _provider.item!.malID,
                              episodePrefix: _provider.item?.episodes,
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
            ),
          );
        }
      )
    );
  }

  Widget _body(AnimeDetailsProvider provider) {
    switch (_state) {
      case DetailState.view:
        final item = provider.item!;

        final animeRelations = groupBy(item.relations, (element) => element.relation);
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            DetailsMainInfo(
                              item.malScore.toStringAsFixed(2),
                              item.status,
                            ),
                            AnimeDetailsInfoColumn(
                              item.titleOriginal,
                              item.titleJP,
                              item.season != null || item.year != null
                              ? "${item.season?.capitalize() ?? '?'} ${item.year ?? '?'}"
                              : "Unknown",
                              item.episodes?.toString() ?? '?',
                              "${item.aired.from != null && item.aired.from != ""
                              ? DateTime.tryParse(item.aired.from!)?.dateToHumanDate()
                              : '?'} to ${item.aired.to != null && item.aired.to != ""
                              ? DateTime.tryParse(item.aired.to!)?.dateToHumanDate()
                              : '?'}",
                              item.source,
                              item.type
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
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
                            child: ContentCell(item.imageUrl, item.title, forceRatio: true, cacheWidth: 300, cacheHeight: 400)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DetailsButtonRow(
                  trailer: item.trailer,
                  _state == DetailState.view ? (
                    _provider.item?.title.isNotEmpty == true ? _provider.item!.title : _provider.item?.titleOriginal ?? _provider.item?.titleJP ?? ''
                  ) : "",
                  _authProvider.isAuthenticated,
                  null,
                  "anime",
                  item.id,
                  () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(builder: (_) {
                        return RecommendationContentList(
                          item.title.isNotEmpty ? item.title : item.titleOriginal,
                          item.id,
                          ContentType.anime.request,
                        );
                      })
                    );
                  }
                ),
                const CustomDivider(height: 0.75, opacity: 0.35),
                const DetailsTitle("Genres"),
                DetailsGenreList(item.genres != null ? item.genres!.map((e) => e.name).toList() : [], (genre) {
                  return AnimeDiscoverListPage(genre: genre);
                }),
                if (item.demographics != null && item.demographics!.isNotEmpty)
                const DetailsTitle("Demographics"),
                if (item.demographics != null && item.demographics!.isNotEmpty)
                DetailsGenreList(item.demographics != null ? item.demographics!.map((e) => e.name).toList() : [], (demographic) {
                  return AnimeDiscoverListPage(demographic: demographic);
                }),
                if (item.themes != null && item.themes!.isNotEmpty)
                const DetailsTitle("Themes"),
                if (item.themes != null && item.themes!.isNotEmpty)
                DetailsGenreList(item.themes != null ? item.themes!.map((e) => e.name).toList() : [], (theme) {
                  return AnimeDiscoverListPage(theme: theme);
                }),
                const DetailsTitle("Description"),
                ExpandableText(
                  item.description,
                  maxLines: 3,
                  expandText: "Read More",
                  collapseText: "Read Less",
                  linkColor: CupertinoColors.systemBlue,
                  style: const TextStyle(fontSize: 16),
                  linkStyle: const TextStyle(fontSize: 14),
                ),
                const DetailsTitle("Characters"),
                SizedBox(
                  height: 115,
                  child: DetailsCommonList(
                    true, item.characters.length,
                    null,
                    (index) {
                      return item.characters[index].image;
                    },
                    (index) {
                      return item.characters[index].name;
                    },
                    (index) {
                      return item.characters[index].role;
                    },
                    false,
                  )
                ),
                if(item.recommendations.isNotEmpty)
                const DetailsTitle("Recommendations"),
                if(item.recommendations.isNotEmpty)
                SizedBox(
                  height: 150,
                  child: DetailsRecommendationList(
                    item.recommendations.length,
                    (index) {
                      return item.recommendations[index].imageURL;
                    },
                    (index) {
                      return item.recommendations[index].title;
                    },
                    (index) {
                      return AnimeDetailsPage(item.recommendations[index].malId.toString());
                    }
                  ),
                ),
                DetailsReviewSummary(
                  item.title.isNotEmpty ? item.title : item.titleOriginal, item.reviewSummary,
                  item.id, null, item.malID,
                  ContentType.anime.request, _fetchData,
                ),
                if (item.streaming != null && item.streaming!.isNotEmpty)
                const DetailsTitle("Streaming Platforms"),
                if (item.streaming != null && item.streaming!.isNotEmpty)
                AnimeDetailsStreamingPlatformsList(item.streaming!),
                if (animeRelations.isNotEmpty)
                const DetailsTitle("Related Anime"),
                for (var animeList in animeRelations.values)
                _relationList(animeList),
                if (item.producers != null && item.producers!.isNotEmpty)
                const DetailsTitle("Producers"),
                if (item.producers != null && item.producers!.isNotEmpty)
                Text(
                  item.producers != null ? item.producers!.map((e) => e.name).join(" • ") : "",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (item.studios != null && item.studios!.isNotEmpty)
                const DetailsTitle("Studios"),
                if (item.studios != null && item.studios!.isNotEmpty)
                DetailsGenreList(item.studios != null ? item.studios!.map((e) => e.name).toList() : [], (studios) {
                  return AnimeDiscoverListPage(studios: studios);
                }),
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

  Widget _relationList(List<AnimeDetailsRelation> relationList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsSubTitle(relationList.first.relation),
        SizedBox(
          height: 115,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: DetailsRecommendationList(
              relationList.length,
              (index) => relationList[index].imageURL,
              (index) => relationList[index].title,
              (index) {
                final item = relationList[index];
                if (item.relation == "Adaptation") {
                  //TODO Redirect or open manga
                }
                return AnimeDetailsPage(item.animeID.toString());
              }
            ),
          ),
        )
      ],
    );
  }
}
