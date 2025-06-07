import 'package:country_picker/country_picker.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/anime/anime_details.dart';
import 'package:watchlistfy/models/main/anime/anime_details_relation.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/models/main/common/trailer.dart';
import 'package:watchlistfy/models/main/game/game_details.dart';
import 'package:watchlistfy/models/main/movie/movie_details.dart';
import 'package:watchlistfy/models/main/tv/tv_details.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/game_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/pages/main/image_page.dart';
import 'package:watchlistfy/pages/main/recommendation/recommendation_content_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/common/base_details_provider.dart';
import 'package:watchlistfy/providers/main/anime/anime_details_provider.dart';
import 'package:watchlistfy/providers/main/game/game_details_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/anime/anime_details_info_column.dart';
import 'package:watchlistfy/widgets/main/anime/anime_details_streaming_platforms_list.dart';
import 'package:watchlistfy/widgets/main/anime/anime_watch_list_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_button_row.dart';
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
import 'package:watchlistfy/widgets/main/game/game_details_info_column.dart';
import 'package:watchlistfy/widgets/main/game/game_details_play_list_sheet.dart';
import 'package:watchlistfy/widgets/main/movie/movie_watch_list_sheet.dart';
import 'package:watchlistfy/widgets/main/tv/tv_seasons_list.dart';
import 'package:watchlistfy/widgets/main/tv/tv_watch_list_sheet.dart';
import "package:collection/collection.dart";

class DetailsPage extends StatefulWidget {
  final String id;
  final ContentType contentType;

  const DetailsPage({
    super.key,
    required this.id,
    required this.contentType,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final BaseDetailsProvider _provider;
  late final AuthenticationProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _provider = _createProvider();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthenticationProvider>(context);
    // Initialize and fetch data with ads handling
    _provider.initializeAndFetch(widget.id, _authProvider);
  }

  BaseDetailsProvider _createProvider() {
    switch (widget.contentType) {
      case ContentType.movie:
        return MovieDetailsProvider();
      case ContentType.tv:
        return TVDetailsProvider();
      case ContentType.anime:
        return AnimeDetailsProvider();
      case ContentType.game:
        return GameDetailsProvider();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<BaseDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                _buildNavigationBar(provider, context, _authProvider),
                _buildBody(provider, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationBar(
    BaseDetailsProvider provider,
    BuildContext context,
    AuthenticationProvider authProvider,
  ) {
    final title = _getTitle(provider.item);
    final contentTypeStr = widget.contentType.request;

    return DetailsNavigationBar(
      title,
      contentTypeStr,
      provider.item == null,
      provider.item?.userList == null,
      provider.item?.consumeLater == null,
      provider.isUserListLoading,
      provider.isLoading,
      onBookmarkTap: () => _handleBookmarkTap(provider, context, authProvider),
      onListTap: () => _handleListTap(provider, context, authProvider),
    );
  }

  String _getTitle(dynamic item) {
    if (item == null) return '';

    switch (widget.contentType) {
      case ContentType.movie:
        final movieItem = item as MovieDetails;
        return movieItem.title.isNotEmpty
            ? movieItem.title
            : movieItem.titleOriginal;
      case ContentType.tv:
        final tvItem = item as TVDetails;
        return tvItem.title.isNotEmpty ? tvItem.title : tvItem.titleOriginal;
      case ContentType.anime:
        final animeItem = item as AnimeDetails;
        return animeItem.title.isNotEmpty
            ? animeItem.title
            : animeItem.titleOriginal;
      case ContentType.game:
        final gameItem = item as GameDetails;
        return gameItem.title.isNotEmpty
            ? gameItem.title
            : gameItem.titleOriginal;
    }
  }

  void _handleBookmarkTap(
    BaseDetailsProvider provider,
    BuildContext context,
    AuthenticationProvider authProvider,
  ) {
    if (!provider.isLoading && authProvider.isAuthenticated) {
      final item = provider.item;

      if (item != null && item.consumeLater != null) {
        _deleteConsumeLater(provider, item.consumeLater!.id, context);
      } else if (item != null) {
        final externalId = _getExternalId(item);
        final itemId = _getId(item);
        _createConsumeLater(provider, itemId, externalId, context);
      }
    } else if (!authProvider.isAuthenticated) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => const UnauthorizedDialog(),
      );
    }
  }

  String _getExternalId(dynamic item) {
    switch (widget.contentType) {
      case ContentType.movie:
        return (item as MovieDetails).tmdbID;
      case ContentType.tv:
        return (item as TVDetails).tmdbID;
      case ContentType.anime:
        return (item as AnimeDetails).malID.toString();
      case ContentType.game:
        return (item as GameDetails).rawgId.toString();
    }
  }

  void _deleteConsumeLater(
    BaseDetailsProvider provider,
    String consumeLaterID,
    BuildContext context,
  ) {
    switch (widget.contentType) {
      case ContentType.movie:
        (provider as MovieDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
      case ContentType.tv:
        (provider as TVDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
      case ContentType.anime:
        (provider as AnimeDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
      case ContentType.game:
        (provider as GameDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
    }
  }

  void _createConsumeLater(
    BaseDetailsProvider provider,
    String itemId,
    String externalId,
    BuildContext context,
  ) {
    switch (widget.contentType) {
      case ContentType.movie:
        (provider as MovieDetailsProvider)
            .createConsumeLaterObject(ConsumeLaterBody(
                itemId, externalId, widget.contentType.request))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
      case ContentType.tv:
        (provider as TVDetailsProvider)
            .createConsumeLaterObject(ConsumeLaterBody(
                itemId, externalId, widget.contentType.request))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
      case ContentType.anime:
        (provider as AnimeDetailsProvider)
            .createConsumeLaterObject(ConsumeLaterBody(
                itemId, externalId, widget.contentType.request))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
      case ContentType.game:
        (provider as GameDetailsProvider)
            .createConsumeLaterObject(ConsumeLaterBody(
                itemId, externalId, widget.contentType.request))
            .then((response) {
          if (context.mounted) {
            _handleConsumerLaterResponse(response, context);
          }
        });
        break;
    }
  }

  void _handleConsumerLaterResponse(response, BuildContext context) {
    if (response.error != null && context.mounted) {
      showCupertinoDialog(
        context: context,
        builder: (_) => ErrorDialog(response.error!),
      );
    }
  }

  void _handleListTap(
    BaseDetailsProvider provider,
    BuildContext context,
    AuthenticationProvider authProvider,
  ) {
    if (!provider.isUserListLoading && authProvider.isAuthenticated) {
      final item = provider.item;

      if (item != null && item.userList != null) {
        _showUserListViewSheet(provider, item, context);
      } else if (item != null) {
        _showCreateListSheet(provider, item, context);
      }
    } else if (!authProvider.isAuthenticated) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => const UnauthorizedDialog(),
      );
    }
  }

  void _showUserListViewSheet(
    BaseDetailsProvider provider,
    dynamic item,
    BuildContext context,
  ) {
    final status = Constants.UserListStatus.firstWhere(
        (element) => element.request == item.userList!.status).name;
    final score = item.userList!.score ?? 'Not Scored';
    final timesFinished = item.userList!.timesFinished;

    String extraInfo = '';
    switch (widget.contentType) {
      case ContentType.movie:
        extraInfo = "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)";
        break;
      case ContentType.tv:
        final episodes = item.userList!.watchedEpisodes ?? "?";
        final seasons = item.userList!.watchedSeasons ?? "?";
        extraInfo =
            "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)\n📺 $seasons seasons $episodes eps";
        break;
      case ContentType.anime:
        final episodes = item.userList!.watchedEpisodes ?? "?";
        extraInfo =
            "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)\n📺 $episodes eps";
        break;
      case ContentType.game:
        final hoursPlayed = item.userList!.watchedEpisodes ?? "?";
        extraInfo =
            "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)\n📺 $hoursPlayed hrs.";
        break;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return UserListViewSheet(
          item.id,
          _getTitle(item),
          extraInfo,
          item.userList!,
          externalID: widget.contentType == ContentType.movie ||
                  widget.contentType == ContentType.tv
              ? _getExternalId(item)
              : null,
          externalIntID: widget.contentType == ContentType.anime ||
                  widget.contentType == ContentType.game
              ? int.tryParse(_getExternalId(item))
              : null,
          contentType: widget.contentType,
          movieProvider: widget.contentType == ContentType.movie
              ? provider as MovieDetailsProvider
              : null,
          tvProvider: widget.contentType == ContentType.tv
              ? provider as TVDetailsProvider
              : null,
          animeProvider: widget.contentType == ContentType.anime
              ? provider as AnimeDetailsProvider
              : null,
          gameProvider: widget.contentType == ContentType.game
              ? provider as GameDetailsProvider
              : null,
          episodePrefix: _getEpisodePrefix(item),
          seasonPrefix: _getSeasonPrefix(item),
        );
      },
    );
  }

  int? _getEpisodePrefix(dynamic item) {
    switch (widget.contentType) {
      case ContentType.tv:
        return (item as TVDetails).totalEpisodes;
      case ContentType.anime:
        return (item as AnimeDetails).episodes;
      default:
        return null;
    }
  }

  int? _getSeasonPrefix(dynamic item) {
    if (widget.contentType == ContentType.tv) {
      return (item as TVDetails).totalSeasons;
    }
    return null;
  }

  void _showCreateListSheet(
    BaseDetailsProvider provider,
    dynamic item,
    BuildContext context,
  ) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        switch (widget.contentType) {
          case ContentType.movie:
            return MovieWatchListSheet(
              provider as MovieDetailsProvider,
              item.id,
              (item as MovieDetails).tmdbID,
            );
          case ContentType.tv:
            return TVWatchListSheet(
              provider as TVDetailsProvider,
              item.id,
              (item as TVDetails).tmdbID,
              episodePrefix: _getEpisodePrefix(item),
              seasonPrefix: _getSeasonPrefix(item),
            );
          case ContentType.anime:
            return AnimeWatchListSheet(
              provider as AnimeDetailsProvider,
              item.id,
              (item as AnimeDetails).malID,
              episodePrefix: _getEpisodePrefix(item),
            );
          case ContentType.game:
            return GameDetailsPlayListSheet(
              provider as GameDetailsProvider,
              item.id,
              (item as GameDetails).rawgId,
            );
        }
      },
    );
  }

  Widget _buildBody(
    BaseDetailsProvider provider,
    BuildContext context,
  ) {
    switch (provider.state) {
      case DetailState.view:
        return _buildViewBody(provider, context);
      case DetailState.error:
        return SliverFillRemaining(
          child: ErrorView(
            provider.error ?? "Unknown error",
            () => provider.refreshData(widget.id),
          ),
        );
      case DetailState.loading:
        return const SliverFillRemaining(child: LoadingView("Loading"));
      default:
        return const SliverFillRemaining(child: LoadingView("Loading"));
    }
  }

  Widget _buildViewBody(BaseDetailsProvider provider, BuildContext context) {
    final item = provider.item!;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainInfo(item, context),
            const SizedBox(height: 12),
            _buildButtonRow(item, context),
            const CustomDivider(height: 0.75, opacity: 0.35),
            ..._buildContentSpecificWidgets(item, context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo(dynamic item, BuildContext context) {
    return Row(
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
                _buildDetailsMainInfo(item),
                _buildDetailsInfoColumn(item),
              ],
            ),
          ),
        ),
        _buildImageSection(item, context),
      ],
    );
  }

  Widget _buildDetailsMainInfo(dynamic item) {
    switch (widget.contentType) {
      case ContentType.movie:
        final movieItem = item as MovieDetails;
        return DetailsMainInfo(
          movieItem.tmdbVote.toStringAsFixed(2),
          movieItem.status,
        );
      case ContentType.tv:
        final tvItem = item as TVDetails;
        return DetailsMainInfo(
          tvItem.tmdbVote.toStringAsFixed(2),
          tvItem.status,
        );
      case ContentType.anime:
        final animeItem = item as AnimeDetails;
        return DetailsMainInfo(
          animeItem.malScore.toStringAsFixed(2),
          animeItem.status,
        );
      case ContentType.game:
        final gameItem = item as GameDetails;
        return DetailsMainInfo(
          gameItem.rawgRating.toStringAsFixed(2),
          gameItem.tba
              ? "TBA"
              : (gameItem.releaseDate != null
                  ? DateTime.parse(gameItem.releaseDate!).dateToHumanDate()
                  : ''),
        );
    }
  }

  Widget _buildDetailsInfoColumn(dynamic item) {
    switch (widget.contentType) {
      case ContentType.movie:
        final movieItem = item as MovieDetails;
        return DetailsInfoColumn(
          movieItem.title != movieItem.titleOriginal,
          movieItem.titleOriginal,
          movieItem.length < 5 ? "?" : movieItem.length.toLength(),
          DateTime.parse(movieItem.releaseDate).dateToHumanDate(),
          null,
          null,
        );
      case ContentType.tv:
        final tvItem = item as TVDetails;
        return DetailsInfoColumn(
          tvItem.title != tvItem.titleOriginal,
          tvItem.titleOriginal,
          null,
          DateTime.parse(tvItem.firstAirDate).dateToHumanDate(),
          tvItem.totalEpisodes,
          tvItem.totalSeasons,
        );
      case ContentType.anime:
        final animeItem = item as AnimeDetails;
        return AnimeDetailsInfoColumn(
          animeItem.titleOriginal,
          animeItem.titleJP,
          animeItem.season != null || animeItem.year != null
              ? "${animeItem.season?.capitalize() ?? '?'} ${animeItem.year ?? '?'}"
              : "Unknown",
          animeItem.episodes?.toString() ?? '?',
          "${animeItem.aired.from != null && animeItem.aired.from != "" ? DateTime.tryParse(animeItem.aired.from!)?.dateToHumanDate() : '?'} to ${animeItem.aired.to != null && animeItem.aired.to != "" ? DateTime.tryParse(animeItem.aired.to!)?.dateToHumanDate() : '?'}",
          animeItem.source,
          animeItem.type,
        );
      case ContentType.game:
        final gameItem = item as GameDetails;
        return Column(
          children: [
            const SizedBox(height: 32),
            GameDetailsInfoColumn(
              gameItem.title != gameItem.titleOriginal,
              gameItem.titleOriginal,
              gameItem.ageRating,
              gameItem.metacriticScore,
            ),
          ],
        );
    }
  }

  Widget _buildImageSection(dynamic item, BuildContext context) {
    final imageUrl = _getImageUrl(item);
    final title = _getTitle(item);

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (_) => ImagePage(imageUrl)),
        );
      },
      child: SizedBox(
        height: 125,
        child: ContentCell(
          imageUrl,
          title,
          forceRatio: true,
          cornerRadius: widget.contentType == ContentType.game ? 8 : 12,
          cacheWidth: 300,
          cacheHeight: 400,
        ),
      ),
    );
  }

  String _getImageUrl(dynamic item) {
    switch (widget.contentType) {
      case ContentType.movie:
        return (item as MovieDetails).imageUrl;
      case ContentType.tv:
        return (item as TVDetails).imageUrl;
      case ContentType.anime:
        return (item as AnimeDetails).imageUrl;
      case ContentType.game:
        return (item as GameDetails).imageUrl;
    }
  }

  Widget _buildButtonRow(dynamic item, BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final title = _getTitle(item);
    final trailers = _getTrailers(item);
    final trailer = _getTrailer(item);

    return DetailsButtonRow(
      title,
      authProvider.isAuthenticated,
      trailers,
      widget.contentType.request,
      _getId(item),
      () => _navigateToRecommendations(item, title, context),
      trailer: trailer,
    );
  }

  List<Trailer>? _getTrailers(dynamic item) {
    switch (widget.contentType) {
      case ContentType.movie:
        return (item as MovieDetails).trailers;
      case ContentType.tv:
        return (item as TVDetails).trailers;
      case ContentType.anime:
      case ContentType.game:
        return null;
    }
  }

  String? _getTrailer(dynamic item) {
    if (widget.contentType == ContentType.anime) {
      return (item as AnimeDetails).trailer;
    }
    return null;
  }

  String _getId(dynamic item) {
    switch (widget.contentType) {
      case ContentType.movie:
        return (item as MovieDetails).id;
      case ContentType.tv:
        return (item as TVDetails).id;
      case ContentType.anime:
        return (item as AnimeDetails).id;
      case ContentType.game:
        return (item as GameDetails).id;
    }
  }

  void _navigateToRecommendations(
    dynamic item,
    String title,
    BuildContext context,
  ) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(builder: (_) {
        return RecommendationContentList(
          title,
          _getId(item),
          widget.contentType.request,
        );
      }),
    );
  }

  List<Widget> _buildContentSpecificWidgets(
    dynamic item,
    BuildContext context,
  ) {
    switch (widget.contentType) {
      case ContentType.movie:
        return _buildMovieWidgets(item as MovieDetails, context);
      case ContentType.tv:
        return _buildTVWidgets(item as TVDetails, context);
      case ContentType.anime:
        return _buildAnimeWidgets(item as AnimeDetails, context);
      case ContentType.game:
        return _buildGameWidgets(item as GameDetails, context);
    }
  }

  List<Widget> _buildMovieWidgets(
    MovieDetails item,
    BuildContext context,
  ) {
    return [
      const DetailsTitle("Genres"),
      DetailsGenreList(
          item.genres, (genre) => MovieDiscoverListPage(genre: genre)),
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
        height: 115,
        child: DetailsCommonList(
          true,
          item.actors.length,
          (index) => item.actors[index].tmdbID,
          (index) => item.actors[index].image,
          (index) => item.actors[index].name,
          (index) => item.actors[index].character,
          true,
        ),
      ),
      if (item.recommendations.isNotEmpty)
        const DetailsTitle("Recommendations"),
      if (item.recommendations.isNotEmpty)
        SizedBox(
          height: 150,
          child: DetailsRecommendationList(
            item.recommendations.length,
            (index) => item.recommendations[index].imageURL,
            (index) => item.recommendations[index].title,
            (index) => DetailsPage(
              id: item.recommendations[index].tmdbID,
              contentType: ContentType.movie,
            ),
          ),
        ),
      DetailsReviewSummary(
        item.title.isNotEmpty ? item.title : item.titleOriginal,
        item.reviewSummary,
        item.id,
        item.tmdbID,
        null,
        ContentType.movie.request,
        () => Provider.of<BaseDetailsProvider>(context, listen: false)
            .refreshData(widget.id),
      ),
      if (item.images.isNotEmpty) const DetailsTitle("Images"),
      if (item.images.isNotEmpty) DetailsCarouselSlider(item.images),
      if (item.productionCompanies != null) const DetailsTitle("Production"),
      if (item.productionCompanies != null)
        SizedBox(
          height: 135,
          child: DetailsCommonList(
            false,
            item.productionCompanies!.length,
            null,
            onClick: (index) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) {
                  return MovieDiscoverListPage(
                    productionCompanies: item.productionCompanies![index].name,
                  );
                }),
              );
            },
            (index) => item.productionCompanies![index].logo,
            (index) => item.productionCompanies![index].name,
            (index) => item.productionCompanies![index].originCountry,
            true,
            placeHolderIcon: Icons.business_rounded,
          ),
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DetailsTitle("Platforms"),
          CupertinoButton(
            child: const Icon(CupertinoIcons.info_circle),
            onPressed: () {
              final countryCode =
                  Provider.of<GlobalProvider>(context, listen: false)
                      .selectedCountryCode;
              showCupertinoDialog(
                context: context,
                builder: (_) => MessageDialog(
                  title:
                      "Your Region is ${Country.tryParse(countryCode)?.name ?? countryCode}",
                  "You can change your region from Settings.",
                ),
              );
            },
          ),
        ],
      ),
      DetailsStreamingLists(item.streaming ?? [], item.tmdbID, "movie"),
    ];
  }

  List<Widget> _buildTVWidgets(
    TVDetails item,
    BuildContext context,
  ) {
    return [
      const DetailsTitle("Genres"),
      DetailsGenreList(
          item.genres, (genre) => TVDiscoverListPage(genre: genre)),
      if (item.description.isNotEmpty) const DetailsTitle("Description"),
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
      if (item.actors.isNotEmpty) const DetailsTitle("Actors"),
      if (item.actors.isNotEmpty)
        SizedBox(
          height: 115,
          child: DetailsCommonList(
            true,
            item.actors.length,
            (index) => item.actors[index].tmdbID,
            (index) => item.actors[index].image,
            (index) => item.actors[index].name,
            (index) => item.actors[index].character,
            false,
          ),
        ),
      if (item.seasons.isNotEmpty) const DetailsTitle("Seasons"),
      SizedBox(
        height: 190,
        child: TVSeasonList(item.seasons),
      ),
      if (item.recommendations.isNotEmpty)
        const DetailsTitle("Recommendations"),
      if (item.recommendations.isNotEmpty)
        SizedBox(
          height: 150,
          child: DetailsRecommendationList(
            item.recommendations.length,
            (index) => item.recommendations[index].imageURL,
            (index) => item.recommendations[index].title,
            (index) => DetailsPage(
              id: item.recommendations[index].tmdbID,
              contentType: ContentType.tv,
            ),
          ),
        ),
      DetailsReviewSummary(
        item.title.isNotEmpty ? item.title : item.titleOriginal,
        item.reviewSummary,
        item.id,
        item.tmdbID,
        null,
        ContentType.tv.request,
        () => Provider.of<BaseDetailsProvider>(context, listen: false)
            .refreshData(widget.id),
      ),
      if (item.images.isNotEmpty) const DetailsTitle("Images"),
      if (item.images.isNotEmpty) DetailsCarouselSlider(item.images),
      if (item.productionCompanies != null) const DetailsTitle("Production"),
      if (item.productionCompanies != null)
        SizedBox(
          height: 135,
          child: DetailsCommonList(
            false,
            item.productionCompanies!.length,
            null,
            onClick: (index) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) {
                  return TVDiscoverListPage(
                    productionCompanies: item.productionCompanies![index].name,
                  );
                }),
              );
            },
            (index) => item.productionCompanies![index].logo,
            (index) => item.productionCompanies![index].name,
            (index) => item.productionCompanies![index].originCountry,
            false,
            placeHolderIcon: Icons.business_rounded,
          ),
        ),
      if (item.networks != null) const DetailsTitle("Networks"),
      if (item.networks != null)
        SizedBox(
          height: 135,
          child: DetailsCommonList(
            false,
            item.networks!.length,
            null,
            (index) => item.networks![index].logo,
            (index) => item.networks![index].name,
            (index) => item.networks![index].originCountry ?? "",
            false,
            placeHolderIcon: Icons.business_rounded,
          ),
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DetailsTitle("Platforms"),
          CupertinoButton(
            child: const Icon(CupertinoIcons.info_circle),
            onPressed: () {
              final countryCode =
                  Provider.of<GlobalProvider>(context, listen: false)
                      .selectedCountryCode;
              showCupertinoDialog(
                context: context,
                builder: (_) => MessageDialog(
                  title:
                      "Your Region is ${Country.tryParse(countryCode)?.name ?? countryCode}",
                  "You can change your region from Settings.",
                ),
              );
            },
          ),
        ],
      ),
      DetailsStreamingLists(item.streaming ?? [], item.tmdbID, "tv"),
    ];
  }

  List<Widget> _buildAnimeWidgets(
    AnimeDetails item,
    BuildContext context,
  ) {
    final animeRelations =
        groupBy(item.relations, (element) => element.relation);

    return [
      const DetailsTitle("Genres"),
      DetailsGenreList(
        item.genres?.map((e) => e.name).toList() ?? [],
        (genre) => AnimeDiscoverListPage(genre: genre),
      ),
      if (item.demographics != null && item.demographics!.isNotEmpty)
        const DetailsTitle("Demographics"),
      if (item.demographics != null && item.demographics!.isNotEmpty)
        DetailsGenreList(
          item.demographics!.map((e) => e.name).toList(),
          (demographic) => AnimeDiscoverListPage(demographic: demographic),
        ),
      if (item.themes != null && item.themes!.isNotEmpty)
        const DetailsTitle("Themes"),
      if (item.themes != null && item.themes!.isNotEmpty)
        DetailsGenreList(
          item.themes!.map((e) => e.name).toList(),
          (theme) => AnimeDiscoverListPage(theme: theme),
        ),
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
          true,
          item.characters.length,
          null,
          (index) => item.characters[index].image,
          (index) => item.characters[index].name,
          (index) => item.characters[index].role,
          false,
        ),
      ),
      if (item.recommendations.isNotEmpty)
        const DetailsTitle("Recommendations"),
      if (item.recommendations.isNotEmpty)
        SizedBox(
          height: 150,
          child: DetailsRecommendationList(
            item.recommendations.length,
            (index) => item.recommendations[index].imageURL,
            (index) => item.recommendations[index].title,
            (index) => DetailsPage(
              id: item.recommendations[index].malId.toString(),
              contentType: ContentType.anime,
            ),
          ),
        ),
      DetailsReviewSummary(
        item.title.isNotEmpty ? item.title : item.titleOriginal,
        item.reviewSummary,
        item.id,
        null,
        item.malID,
        ContentType.anime.request,
        () => Provider.of<BaseDetailsProvider>(context, listen: false)
            .refreshData(widget.id),
      ),
      if (item.streaming != null && item.streaming!.isNotEmpty)
        const DetailsTitle("Streaming Platforms"),
      if (item.streaming != null && item.streaming!.isNotEmpty)
        AnimeDetailsStreamingPlatformsList(item.streaming!),
      if (animeRelations.isNotEmpty) const DetailsTitle("Related Anime"),
      ...animeRelations.values
          .map((animeList) => _buildRelationList(animeList)),
      if (item.producers != null && item.producers!.isNotEmpty)
        const DetailsTitle("Producers"),
      if (item.producers != null && item.producers!.isNotEmpty)
        Text(
          item.producers!.map((e) => e.name).join(" • "),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      if (item.studios != null && item.studios!.isNotEmpty)
        const DetailsTitle("Studios"),
      if (item.studios != null && item.studios!.isNotEmpty)
        DetailsGenreList(
          item.studios!.map((e) => e.name).toList(),
          (studios) => AnimeDiscoverListPage(studios: studios),
        ),
    ];
  }

  Widget _buildRelationList(List<AnimeDetailsRelation> relationList) {
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
                return DetailsPage(
                  id: item.animeID.toString(),
                  contentType: ContentType.anime,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGameWidgets(GameDetails item, BuildContext context) {
    return [
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
      DetailsGenreList(
        item.genres,
        (genre) => GameDiscoverListPage(genre: genre),
      ),
      if (item.developers.isNotEmpty) const DetailsTitle("Developers"),
      if (item.developers.isNotEmpty)
        Text(
          item.developers.join(" • "),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      if (item.publishers.isNotEmpty) const DetailsTitle("Publishers"),
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
                      return GameDiscoverListPage(publisher: publisher);
                    }),
                  );
                },
                label: publisher,
              );
            },
          ),
        ),
      const DetailsTitle("Platforms"),
      DetailsGenreList(
        item.platforms,
        (platform) => GameDiscoverListPage(platform: platform),
      ),
      if (item.relatedGames.isNotEmpty) const DetailsTitle("Related Games"),
      if (item.relatedGames.isNotEmpty)
        SizedBox(
          height: 150,
          child: DetailsRecommendationList(
            item.relatedGames.length,
            (index) => item.relatedGames[index].imageURL,
            (index) => item.relatedGames[index].title,
            (index) => DetailsPage(
              id: item.relatedGames[index].rawgId.toString(),
              contentType: ContentType.game,
            ),
          ),
        ),
      DetailsReviewSummary(
        item.title.isNotEmpty ? item.title : item.titleOriginal,
        item.reviewSummary,
        item.id,
        null,
        item.rawgId,
        ContentType.game.request,
        () => Provider.of<BaseDetailsProvider>(context, listen: false)
            .refreshData(widget.id),
      ),
      if (item.screenshots.isNotEmpty) const DetailsTitle("Screenshots"),
      if (item.screenshots.isNotEmpty) DetailsCarouselSlider(item.screenshots),
    ];
  }
}
