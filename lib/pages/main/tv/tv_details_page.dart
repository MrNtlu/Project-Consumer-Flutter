import 'package:country_picker/country_picker.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/pages/main/image_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/trailer_sheet.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_carousel_slider.dart';
import 'package:watchlistfy/widgets/main/common/details_character_list.dart';
import 'package:watchlistfy/widgets/main/common/details_genre_list.dart';
import 'package:watchlistfy/widgets/main/common/details_info_column.dart';
import 'package:watchlistfy/widgets/main/common/details_main_info.dart';
import 'package:watchlistfy/widgets/main/common/details_navigation_bar.dart';
import 'package:watchlistfy/widgets/main/common/details_recommendation_list.dart';
import 'package:watchlistfy/widgets/main/common/details_review_summary.dart';
import 'package:watchlistfy/widgets/main/common/details_streaming_lists.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';
import 'package:watchlistfy/widgets/main/tv/tv_seasons_list.dart';
import 'package:watchlistfy/widgets/main/tv/tv_watch_list_sheet.dart';

class TVDetailsPage extends StatefulWidget {
  final String id;

  const TVDetailsPage(this.id, {super.key});

  @override
  State<TVDetailsPage> createState() => _TVDetailsPageState();
}

class _TVDetailsPageState extends State<TVDetailsPage> {
  DetailState _state = DetailState.init;

  late final TVDetailsProvider _provider;
  late final AuthenticationProvider _authProvider;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getTVDetails(widget.id).then((response) {
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
    _provider = TVDetailsProvider();
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
      child: Consumer<TVDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                DetailsNavigationBar(
                  _provider.item?.title.isNotEmpty == true ? _provider.item!.title : _provider.item?.titleOriginal ?? '',
                  "tv",
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
                          ConsumeLaterBody(item.id, item.tmdbID, "tv")
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
                        final seasons = item.userList!.watchedSeasons ?? "?";
                        final timesFinished = item.userList!.timesFinished;

                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return UserListViewSheet(
                              _provider.item!.id,
                              _provider.item!.title,
                              "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)\n📺 $seasons seasons $episodes eps",
                              _provider.item!.userList!,
                              externalID: _provider.item!.tmdbID,
                              contentType: ContentType.tv,
                              tvProvider: provider,
                              episodePrefix: _provider.item?.totalEpisodes,
                              seasonPrefix: _provider.item?.totalSeasons,
                            );
                          }
                        );
                      } else if (item != null) {
                        showCupertinoModalPopup(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return TVWatchListSheet(
                              _provider,
                              _provider.item!.id,
                              _provider.item!.tmdbID,
                              episodePrefix: _provider.item?.totalEpisodes,
                              seasonPrefix: _provider.item?.totalSeasons,
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

  Widget _body(TVDetailsProvider provider) {
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
                      child: SizedBox(
                        height: item.title != item.titleOriginal ? 162 : 145,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              DetailsMainInfo(
                                item.tmdbVote.toStringAsFixed(2),
                                item.status,
                                "tv",
                                item.id,
                              ),
                              DetailsInfoColumn(
                                item.title != item.titleOriginal,
                                item.titleOriginal,
                                null,
                                DateTime.parse(item.firstAirDate).dateToHumanDate(),
                                item.totalEpisodes,
                                item.totalSeasons,
                              )
                            ],
                          ),
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
                        if (item.trailers != null && item.trailers!.isNotEmpty)
                        const SizedBox(height: 8),
                        if (item.trailers != null && item.trailers!.isNotEmpty)
                        SizedBox(
                          width: 85,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.play_rectangle_fill, size: 18),
                                SizedBox(width: 6),
                                Text("Trailers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            onPressed: () {
                              showCupertinoModalBottomSheet(
                                context: context,
                                barrierColor: CupertinoColors.black.withOpacity(0.75),
                                builder: (_) => TrailerSheet(item.trailers!)
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                const CustomDivider(height: 0.75, opacity: 0.35),
                const DetailsTitle("Genres"),
                DetailsGenreList(item.genres, (genre) {
                  return TVDiscoverListPage(genre: genre);
                }),
                if (item.description.isNotEmpty)
                const DetailsTitle("Description"),
                if (item.description.isNotEmpty)
                ExpandableText(
                  item.description,
                  maxLines: 3,
                  expandText: "Read More",
                  collapseText: "Read Less",
                  linkColor: CupertinoColors.systemBlue,
                  style: const TextStyle(fontSize: 16),
                  linkStyle: const TextStyle(fontSize: 14),
                ),
                if (item.actors.isNotEmpty)
                const DetailsTitle("Actors"),
                if (item.actors.isNotEmpty)
                SizedBox(
                  height: 110,
                  child: DetailsCommonList(
                    true, item.actors.length,
                    (index) {
                      return item.actors[index].tmdbID;
                    },
                    (index) {
                      return item.actors[index].image;
                    },
                    (index) {
                      return item.actors[index].name;
                    },
                    (index) {
                      return item.actors[index].character;
                    },
                    false,
                  )
                ),
                if (item.seasons.isNotEmpty)
                const DetailsTitle("Seasons"),
                SizedBox(
                  height: 190,
                  child: TVSeasonList(item.seasons),
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
                      return TVDetailsPage(item.recommendations[index].tmdbID);
                    }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DetailsTitle("Platforms"),
                    CupertinoButton(
                      child: const Icon(CupertinoIcons.info_circle),
                      onPressed: () {
                        final countryCode = Provider.of<GlobalProvider>(context, listen: false).selectedCountryCode;

                        showCupertinoDialog(
                          context: context,
                          builder: (_) => MessageDialog(
                            title: "Your Region is ${Country.tryParse(countryCode)?.name ?? countryCode}",
                            "You can change your region from Settings."
                          )
                        );
                      }
                    )
                  ],
                ),
                DetailsStreamingLists(item.streaming ?? [], item.tmdbID, "tv"),
                DetailsReviewSummary(
                  item.title.isNotEmpty ? item.title : item.titleOriginal,
                  item.reviewSummary, item.id,
                  item.tmdbID, null,
                  ContentType.tv.request, _fetchData,
                ),
                if (item.images.isNotEmpty)
                const DetailsTitle("Images"),
                if (item.images.isNotEmpty)
                DetailsCarouselSlider(item.images),
                if(item.productionCompanies != null)
                const DetailsTitle("Production"),
                if(item.productionCompanies != null)
                SizedBox(
                  height: 130,
                  child: DetailsCommonList(
                    false, item.productionCompanies!.length,
                    null,
                    onClick: (index) {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(builder: (_) {
                          return TVDiscoverListPage(productionCompanies: item.productionCompanies![index].name);
                        })
                      );
                    },
                    (index) {
                      return item.productionCompanies![index].logo;
                    },
                    (index) {
                      return item.productionCompanies![index].name;
                    },
                    (index) {
                      return item.productionCompanies![index].originCountry;
                    },
                    false,
                    placeHolderIcon: Icons.business_rounded,
                  )
                ),
                if(item.networks != null)
                const DetailsTitle("Networks"),
                if(item.networks != null)
                SizedBox(
                  height: 130,
                  child: DetailsCommonList(
                    false, item.networks!.length,
                    null,
                    (index) {
                      return item.networks![index].logo;
                    },
                    (index) {
                      return item.networks![index].name;
                    },
                    (index) {
                      return item.networks![index].originCountry ?? "";
                    },
                    false,
                    placeHolderIcon: Icons.business_rounded,
                  )
                ),
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