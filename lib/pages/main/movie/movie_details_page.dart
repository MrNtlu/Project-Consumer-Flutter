import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/image_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/trailer_sheet.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/main/common/details_carousel_slider.dart';
import 'package:watchlistfy/widgets/main/common/details_genre_list.dart';
import 'package:watchlistfy/widgets/main/common/details_navigation_bar.dart';
import 'package:watchlistfy/widgets/main/common/details_review_summary.dart';
import 'package:watchlistfy/widgets/main/common/details_streaming_lists.dart';
import 'package:watchlistfy/widgets/main/movie/movie_watch_list_sheet.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_character_list.dart';
import 'package:watchlistfy/widgets/main/common/details_info_column.dart';
import 'package:watchlistfy/widgets/main/common/details_main_info.dart';
import 'package:watchlistfy/widgets/main/common/details_recommendation_list.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

class MovieDetailsPage extends StatefulWidget {
  final String id;

  const MovieDetailsPage(this.id, {super.key});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  DetailState _state = DetailState.init;

  late final MovieDetailsProvider _provider;
  late final AuthenticationProvider _authProvider;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getMovieDetails(widget.id).then((response) {
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
    _provider = MovieDetailsProvider();
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
      child: Consumer<MovieDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                DetailsNavigationBar(
                  _provider.item?.title.isNotEmpty == true ? _provider.item!.title : _provider.item?.titleOriginal ?? '',
                  "movie",
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
                          ConsumeLaterBody(item.id, item.tmdbID, "movie")
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
                        final timesFinished = item.userList!.timesFinished;

                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return UserListViewSheet(
                              _provider.item!.id,
                              _provider.item!.title,
                              "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)",
                              _provider.item!.userList!,
                              externalID: _provider.item!.tmdbID,
                              contentType: ContentType.movie,
                              movieProvider: provider,
                            );
                          }
                        );
                      } else if (item != null) {
                        showCupertinoModalPopup(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return MovieWatchListSheet(_provider, _provider.item!.id, _provider.item!.tmdbID);
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

  Widget _body(MovieDetailsProvider provider) {
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
                                "movie",
                                item.id,
                              ),
                              DetailsInfoColumn(
                                item.title != item.titleOriginal,
                                item.titleOriginal,
                                item.length.toLength(),
                                DateTime.parse(item.releaseDate).dateToHumanDate(),
                                null, null,
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
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                const CustomDivider(height: 0.75, opacity: 0.35),
                const DetailsTitle("Genres"),
                DetailsGenreList(item.genres, (genre) {
                  return MovieDiscoverListPage(genre: genre);
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
                const DetailsTitle("Actors"),
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
                    true,
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
                      return MovieDetailsPage(item.recommendations[index].tmdbID);
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
                DetailsStreamingLists(item.streaming ?? [], item.tmdbID, "movie"),
                DetailsReviewSummary(
                  item.title.isNotEmpty ? item.title : item.titleOriginal,
                  item.reviewSummary, item.id, item.tmdbID,
                  null, ContentType.movie.request, _fetchData,
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
                    (index) {
                      return item.productionCompanies![index].logo;
                    },
                    (index) {
                      return item.productionCompanies![index].name;
                    },
                    (index) {
                      return item.productionCompanies![index].originCountry;
                    },
                    placeHolderIcon: Icons.business_rounded,
                    true,
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
