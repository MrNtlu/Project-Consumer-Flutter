import 'package:country_picker/country_picker.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/notification_overlay.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/anime/anime_details_info_column.dart';
import 'package:watchlistfy/widgets/main/anime/anime_details_streaming_platforms_list.dart';
import 'package:watchlistfy/widgets/main/anime/anime_watch_list_sheet.dart';
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
import 'package:watchlistfy/widgets/main/common/details_user_action_row.dart';
import 'package:watchlistfy/widgets/main/game/game_details_info_column.dart';
import 'package:watchlistfy/widgets/main/game/game_details_play_list_sheet.dart';
import 'package:watchlistfy/widgets/main/movie/movie_watch_list_sheet.dart';
import 'package:watchlistfy/widgets/main/tv/tv_seasons_list.dart';
import 'package:watchlistfy/widgets/main/tv/tv_watch_list_sheet.dart';
import "package:collection/collection.dart";

// Create a memoized item adapter to reduce switch statement overhead
class DetailsItemAdapter {
  final dynamic item;
  final ContentType contentType;

  // Cached properties for performance
  late final String _title;
  late final String _imageUrl;
  late final String _externalId;
  late final String _id;
  late final List<Trailer>? _trailers;
  late final String? _trailer;
  late final int? _episodePrefix;
  late final int? _seasonPrefix;

  DetailsItemAdapter(this.item, this.contentType) {
    _cacheProperties();
  }

  void _cacheProperties() {
    switch (contentType) {
      case ContentType.movie:
        final movieItem = item as MovieDetails;
        _title = movieItem.title.isNotEmpty
            ? movieItem.title
            : movieItem.titleOriginal;
        _imageUrl = movieItem.imageUrl;
        _externalId = movieItem.tmdbID;
        _id = movieItem.id;
        _trailers = movieItem.trailers;
        _trailer = null;
        _episodePrefix = null;
        _seasonPrefix = null;
        break;
      case ContentType.tv:
        final tvItem = item as TVDetails;
        _title = tvItem.title.isNotEmpty ? tvItem.title : tvItem.titleOriginal;
        _imageUrl = tvItem.imageUrl;
        _externalId = tvItem.tmdbID;
        _id = tvItem.id;
        _trailers = tvItem.trailers;
        _trailer = null;
        _episodePrefix = tvItem.totalEpisodes;
        _seasonPrefix = tvItem.totalSeasons;
        break;
      case ContentType.anime:
        final animeItem = item as AnimeDetails;
        _title = animeItem.title.isNotEmpty
            ? animeItem.title
            : animeItem.titleOriginal;
        _imageUrl = animeItem.imageUrl;
        _externalId = animeItem.malID.toString();
        _id = animeItem.id;
        _trailers = null;
        _trailer = animeItem.trailer;
        _episodePrefix = animeItem.episodes;
        _seasonPrefix = null;
        break;
      case ContentType.game:
        final gameItem = item as GameDetails;
        _title =
            gameItem.title.isNotEmpty ? gameItem.title : gameItem.titleOriginal;
        _imageUrl = gameItem.imageUrl;
        _externalId = gameItem.rawgId.toString();
        _id = gameItem.id;
        _trailers = null;
        _trailer = null;
        _episodePrefix = null;
        _seasonPrefix = null;
        break;
    }
  }

  String get title => _title;
  String get imageUrl => _imageUrl;
  String get externalId => _externalId;
  String get id => _id;
  List<Trailer>? get trailers => _trailers;
  String? get trailer => _trailer;
  int? get episodePrefix => _episodePrefix;
  int? get seasonPrefix => _seasonPrefix;
}

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
  late AuthenticationProvider _authProvider;

  // Cache adapter for performance
  DetailsItemAdapter? _itemAdapter;

  // ValueNotifiers for granular updates
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isUserListLoadingNotifier = ValueNotifier(false);

  // Cache method references to avoid repeated lookups
  late final VoidCallback _onProviderChangedCallback;

  @override
  void initState() {
    super.initState();
    _provider = _createProvider();

    // Cache the callback to avoid creating new instances
    _onProviderChangedCallback = _onProviderChanged;
    _provider.addListener(_onProviderChangedCallback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    // Defer heavy network call to avoid blocking navigation animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _provider.initializeAndFetch(widget.id, _authProvider);
      }
    });
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChangedCallback);
    _isLoadingNotifier.dispose();
    _isUserListLoadingNotifier.dispose();
    super.dispose();
  }

  void _onProviderChanged() {
    if (mounted) {
      // Batch updates to reduce rebuilds
      final isLoading = _provider.isLoading;
      final isUserListLoading = _provider.isUserListLoading;

      if (_isLoadingNotifier.value != isLoading) {
        _isLoadingNotifier.value = isLoading;
      }

      if (_isUserListLoadingNotifier.value != isUserListLoading) {
        _isUserListLoadingNotifier.value = isUserListLoading;
      }

      // Update adapter only once when item first becomes available
      if (_provider.item != null && _itemAdapter == null) {
        _itemAdapter = DetailsItemAdapter(_provider.item!, widget.contentType);
      }
    }
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
              physics: const BouncingScrollPhysics(),
              cacheExtent: 0,
              slivers: [
                _buildNavigationBar(provider),
                _buildBody(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavigationBar(BaseDetailsProvider provider) {
    return ValueListenableBuilder(
      valueListenable: _isLoadingNotifier,
      builder: (context, isLoading, child) {
        return ValueListenableBuilder(
          valueListenable: _isUserListLoadingNotifier,
          builder: (context, isUserListLoading, child) {
            final title = _itemAdapter?.title ?? '';
            final adapter = _itemAdapter;

            return DetailsNavigationBar(
              title,
              widget.contentType.request,
              widget.id,
              adapter?.trailers,
              adapter?.trailer,
              provider.item == null,
              () => _navigateToRecommendations(adapter!),
            );
          },
        );
      },
    );
  }

  void _handleBookmarkTap(BaseDetailsProvider provider) {
    if (!_isLoadingNotifier.value && _authProvider.isAuthenticated) {
      final item = provider.item;
      final adapter = _itemAdapter;

      if (item != null && adapter != null) {
        if (item.consumeLater != null) {
          _deleteConsumeLater(provider, item.consumeLater!.id);
        } else {
          _createConsumeLater(provider, adapter.id, adapter.externalId);
        }
      }
    } else if (!_authProvider.isAuthenticated) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => const UnauthorizedDialog(),
      );
    }
  }

  void _deleteConsumeLater(
    BaseDetailsProvider provider,
    String consumeLaterID,
  ) {
    switch (widget.contentType) {
      case ContentType.movie:
        (provider as MovieDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) => _handleConsumerLaterResponse(response));
        break;
      case ContentType.tv:
        (provider as TVDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) => _handleConsumerLaterResponse(response));
        break;
      case ContentType.anime:
        (provider as AnimeDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) => _handleConsumerLaterResponse(response));
        break;
      case ContentType.game:
        (provider as GameDetailsProvider)
            .deleteConsumeLaterObject(IDBody(consumeLaterID))
            .then((response) => _handleConsumerLaterResponse(response));
        break;
    }
  }

  void _createConsumeLater(
    BaseDetailsProvider provider,
    String itemId,
    String externalId,
  ) {
    switch (widget.contentType) {
      case ContentType.movie:
        (provider as MovieDetailsProvider)
            .createConsumeLaterObject(
              ConsumeLaterBody(
                itemId,
                externalId,
                widget.contentType.request,
              ),
            )
            .then(
              (response) => _handleConsumerLaterResponse(response),
            );
        break;
      case ContentType.tv:
        (provider as TVDetailsProvider)
            .createConsumeLaterObject(
              ConsumeLaterBody(
                itemId,
                externalId,
                widget.contentType.request,
              ),
            )
            .then(
              (response) => _handleConsumerLaterResponse(response),
            );
        break;
      case ContentType.anime:
        (provider as AnimeDetailsProvider)
            .createConsumeLaterObject(
              ConsumeLaterBody(
                itemId,
                externalId,
                widget.contentType.request,
              ),
            )
            .then(
              (response) => _handleConsumerLaterResponse(response),
            );
        break;
      case ContentType.game:
        (provider as GameDetailsProvider)
            .createConsumeLaterObject(
              ConsumeLaterBody(
                itemId,
                externalId,
                widget.contentType.request,
              ),
            )
            .then(
              (response) => _handleConsumerLaterResponse(response),
            );
        break;
    }
  }

  void _handleConsumerLaterResponse(response) {
    if (response.error != null && mounted) {
      NotificationOverlay().show(
        context,
        title: "Error",
        message: response.error!,
        isError: true,
      );
    }
  }

  void _handleListTap(BaseDetailsProvider provider) {
    if (!_isUserListLoadingNotifier.value && _authProvider.isAuthenticated) {
      final item = provider.item;

      if (item != null) {
        if (item.userList != null) {
          _showUserListViewSheet(provider, item);
        } else {
          _showCreateListSheet(provider, item);
        }
      }
    } else if (!_authProvider.isAuthenticated) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => const UnauthorizedDialog(),
      );
    }
  }

  void _showUserListViewSheet(BaseDetailsProvider provider, dynamic item) {
    final adapter = _itemAdapter!;
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
          adapter.id,
          adapter.title,
          extraInfo,
          item.userList!,
          externalID: widget.contentType == ContentType.movie ||
                  widget.contentType == ContentType.tv
              ? adapter.externalId
              : null,
          externalIntID: widget.contentType == ContentType.anime ||
                  widget.contentType == ContentType.game
              ? int.tryParse(adapter.externalId)
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
          episodePrefix: adapter.episodePrefix,
          seasonPrefix: adapter.seasonPrefix,
        );
      },
    );
  }

  void _showCreateListSheet(BaseDetailsProvider provider, dynamic item) {
    final adapter = _itemAdapter!;

    showCupertinoModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      barrierColor: CupertinoColors.white.withValues(alpha: 0.2),
      builder: (context) {
        switch (widget.contentType) {
          case ContentType.movie:
            return MovieWatchListSheet(
              provider as MovieDetailsProvider,
              adapter.id,
              adapter.externalId,
            );
          case ContentType.tv:
            return TVWatchListSheet(
              provider as TVDetailsProvider,
              adapter.id,
              adapter.externalId,
              episodePrefix: adapter.episodePrefix,
              seasonPrefix: adapter.seasonPrefix,
            );
          case ContentType.anime:
            return AnimeWatchListSheet(
              provider as AnimeDetailsProvider,
              adapter.id,
              int.parse(adapter.externalId),
              episodePrefix: adapter.episodePrefix,
            );
          case ContentType.game:
            return GameDetailsPlayListSheet(
              provider as GameDetailsProvider,
              adapter.id,
              int.parse(adapter.externalId),
            );
        }
      },
    );
  }

  Widget _buildBody(BaseDetailsProvider provider) {
    switch (provider.state) {
      case DetailState.view:
        return _buildViewBody(provider);
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

  Widget _buildViewBody(BaseDetailsProvider provider) {
    final item = provider.item!;
    final adapter = _itemAdapter!;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OptimizedMainInfo(
              item: item,
              adapter: adapter,
              contentType: widget.contentType,
            ),
            const SizedBox(height: 12),
            _OptimizedUserActionRow(
              item: item,
              provider: provider,
              onListTap: () => _handleListTap(provider),
              onBookmarkTap: () => _handleBookmarkTap(provider),
            ),
            const CustomDivider(height: 0.75, opacity: 0.35),
            _OptimizedContentWidgets(
              item: item,
              contentType: widget.contentType,
              onRefresh: () => provider.refreshData(
                widget.id,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _navigateToRecommendations(DetailsItemAdapter adapter) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(builder: (_) {
        return RecommendationContentList(
          adapter.title,
          adapter.id,
          widget.contentType.request,
        );
      }),
    );
  }
}

// Optimized widgets to reduce rebuilds
class _OptimizedMainInfo extends StatelessWidget {
  final dynamic item;
  final DetailsItemAdapter adapter;
  final ContentType contentType;

  const _OptimizedMainInfo({
    required this.item,
    required this.adapter,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
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
                _buildDetailsMainInfo(),
                _buildDetailsInfoColumn(),
              ],
            ),
          ),
        ),
        _buildImageSection(context),
      ],
    );
  }

  Widget _buildDetailsMainInfo() {
    switch (contentType) {
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

  Widget _buildDetailsInfoColumn() {
    switch (contentType) {
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

  Widget _buildImageSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
            builder: (_) => ImagePage(
              adapter.imageUrl,
              heroTag: 'details_image_${adapter.id}',
            ),
          ),
        );
      },
      child: SizedBox(
        height: 125,
        child: Hero(
          tag: 'details_image_${adapter.id}',
          child: ContentCell(
            adapter.imageUrl.replaceFirst("original", "w300"),
            adapter.title,
            forceRatio: true,
            cornerRadius: contentType == ContentType.game ? 8 : 12,
            cacheWidth: 300,
            cacheHeight: 400,
          ),
        ),
      ),
    );
  }
}

class _OptimizedUserActionRow extends StatelessWidget {
  final dynamic item;
  final BaseDetailsProvider provider;
  final VoidCallback onListTap;
  final VoidCallback onBookmarkTap;

  const _OptimizedUserActionRow({
    required this.item,
    required this.provider,
    required this.onListTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return DetailsUserActionRow(
      isAuthenticated: authProvider.isAuthenticated,
      isUserListNull: item?.userList == null,
      isBookmarkNull: item?.consumeLater == null,
      isUserListLoading: provider.isUserListLoading,
      isBookmarkLoading: provider.isLoading,
      onListTap: onListTap,
      onBookmarkTap: onBookmarkTap,
    );
  }
}

class _OptimizedContentWidgets extends StatelessWidget {
  final dynamic item;
  final ContentType contentType;
  final VoidCallback onRefresh;

  const _OptimizedContentWidgets({
    required this.item,
    required this.contentType,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    switch (contentType) {
      case ContentType.movie:
        return _MovieDetailsContent(
          item: item as MovieDetails,
          onRefresh: onRefresh,
        );
      case ContentType.tv:
        return _TVDetailsContent(
          item: item as TVDetails,
          onRefresh: onRefresh,
        );
      case ContentType.anime:
        return _AnimeDetailsContent(
          item: item as AnimeDetails,
          onRefresh: onRefresh,
        );
      case ContentType.game:
        return _GameDetailsContent(
          item: item as GameDetails,
          onRefresh: onRefresh,
        );
    }
  }
}

// Optimized content-specific widgets to reduce rebuilds
class _MovieDetailsContent extends StatelessWidget {
  final MovieDetails item;
  final VoidCallback onRefresh;

  const _MovieDetailsContent({
    required this.item,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailsTitle("Genres"),
        DetailsGenreList(
          item.genres,
          (genre) => MovieDiscoverListPage(
            genre: genre,
          ),
        ),
        const DetailsTitle("Synopsis"),
        ExpandableText(
          item.description,
          maxLines: 3,
          expandText: "Read More",
          collapseText: "Read Less",
          linkColor: CupertinoColors.systemBlue,
          style: const TextStyle(fontSize: 16),
          linkStyle: const TextStyle(fontSize: 14),
        ),
        if (item.actors.isNotEmpty) ...[
          const DetailsTitle("Cast"),
          DetailsCommonList(
            true,
            item.actors.length,
            (index) => item.actors[index].tmdbID,
            (index) => item.actors[index].image,
            (index) => item.actors[index].name,
            (index) => item.actors[index].character,
            true,
          ),
        ],
        if (item.recommendations.isNotEmpty) ...[
          const DetailsTitle("Recommendations"),
          DetailsRecommendationList(
            item.recommendations.length,
            (index) => item.recommendations[index].imageURL,
            (index) => item.recommendations[index].title,
            (index) => DetailsPage(
              id: item.recommendations[index].tmdbID,
              contentType: ContentType.movie,
            ),
          ),
        ],
        DetailsReviewSummary(
          item.title.isNotEmpty ? item.title : item.titleOriginal,
          item.reviewSummary,
          item.id,
          item.tmdbID,
          null,
          ContentType.movie.request,
          onRefresh,
        ),
        if (item.images.isNotEmpty) ...[
          const DetailsTitle("Images"),
          DetailsCarouselSlider(item.images),
        ],
        if (item.productionCompanies != null) ...[
          const DetailsTitle("Production"),
          DetailsCommonList(
            false,
            item.productionCompanies!.length,
            null,
            onClick: (index) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) => MovieDiscoverListPage(
                    productionCompanies: item.productionCompanies![index].name,
                  ),
                ),
              );
            },
            (index) => item.productionCompanies![index].logo,
            (index) => item.productionCompanies![index].name,
            (index) => item.productionCompanies![index].originCountry,
            true,
            placeHolderIcon: Icons.business_rounded,
          ),
        ],
        _PlatformsSection(
          countryCode: () => Provider.of<GlobalProvider>(context, listen: false)
              .selectedCountryCode,
        ),
        DetailsStreamingLists(
          item.streaming ?? [],
          item.tmdbID,
          "movie",
        ),
      ],
    );
  }
}

class _TVDetailsContent extends StatelessWidget {
  final TVDetails item;
  final VoidCallback onRefresh;

  const _TVDetailsContent({
    required this.item,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailsTitle("Genres"),
        DetailsGenreList(
          item.genres,
          (genre) => TVDiscoverListPage(
            genre: genre,
          ),
        ),
        if (item.description.isNotEmpty) ...[
          const DetailsTitle("Synopsis"),
          ExpandableText(
            item.description,
            maxLines: 3,
            expandText: "Read More",
            collapseText: "Read Less",
            linkColor: CupertinoColors.systemBlue,
            style: const TextStyle(fontSize: 16),
            linkStyle: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
        if (item.actors.isNotEmpty) ...[
          const DetailsTitle("Cast"),
          DetailsCommonList(
            true,
            item.actors.length,
            (index) => item.actors[index].tmdbID,
            (index) => item.actors[index].image,
            (index) => item.actors[index].name,
            (index) => item.actors[index].character,
            false,
          ),
        ],
        if (item.seasons.isNotEmpty) ...[
          const DetailsTitle("Seasons"),
          TVSeasonList(item.seasons),
        ],
        if (item.recommendations.isNotEmpty) ...[
          const DetailsTitle("Recommendations"),
          DetailsRecommendationList(
            item.recommendations.length,
            (index) => item.recommendations[index].imageURL,
            (index) => item.recommendations[index].title,
            (index) => DetailsPage(
              id: item.recommendations[index].tmdbID,
              contentType: ContentType.tv,
            ),
          ),
        ],
        DetailsReviewSummary(
            item.title.isNotEmpty ? item.title : item.titleOriginal,
            item.reviewSummary,
            item.id,
            item.tmdbID,
            null,
            ContentType.tv.request,
            onRefresh),
        if (item.images.isNotEmpty) ...[
          const DetailsTitle("Images"),
          DetailsCarouselSlider(item.images)
        ],
        if (item.productionCompanies != null) ...[
          const DetailsTitle("Production"),
          DetailsCommonList(
            false,
            item.productionCompanies!.length,
            null,
            onClick: (index) => Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (_) => TVDiscoverListPage(
                    productionCompanies: item.productionCompanies![index].name),
              ),
            ),
            (index) => item.productionCompanies![index].logo,
            (index) => item.productionCompanies![index].name,
            (index) => item.productionCompanies![index].originCountry,
            false,
            placeHolderIcon: Icons.business_rounded,
          ),
        ],
        if (item.networks != null) ...[
          const DetailsTitle("Networks"),
          DetailsCommonList(
            false,
            item.networks!.length,
            null,
            (index) => item.networks![index].logo,
            (index) => item.networks![index].name,
            (index) => item.networks![index].originCountry ?? "",
            false,
            placeHolderIcon: Icons.business_rounded,
          ),
        ],
        _PlatformsSection(
          countryCode: () => Provider.of<GlobalProvider>(
            context,
            listen: false,
          ).selectedCountryCode,
        ),
        DetailsStreamingLists(
          item.streaming ?? [],
          item.tmdbID,
          "tv",
        ),
      ],
    );
  }
}

class _AnimeDetailsContent extends StatelessWidget {
  final AnimeDetails item;
  final VoidCallback onRefresh;

  const _AnimeDetailsContent({
    required this.item,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final animeRelations = groupBy(
      item.relations,
      (element) => element.relation,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailsTitle("Genres"),
        DetailsGenreList(
          item.genres?.map((e) => e.name).toList() ?? [],
          (genre) => AnimeDiscoverListPage(
            genre: genre,
          ),
        ),
        if (item.demographics?.isNotEmpty == true) ...[
          const DetailsTitle("Demographics"),
          DetailsGenreList(
            item.demographics!.map((e) => e.name).toList(),
            (demographic) => AnimeDiscoverListPage(
              demographic: demographic,
            ),
          ),
        ],
        if (item.themes?.isNotEmpty == true) ...[
          const DetailsTitle("Themes"),
          DetailsGenreList(
            item.themes!.map((e) => e.name).toList(),
            (theme) => AnimeDiscoverListPage(
              theme: theme,
            ),
          ),
        ],
        const DetailsTitle("Synopsis"),
        ExpandableText(
          item.description,
          maxLines: 3,
          expandText: "Read More",
          collapseText: "Read Less",
          linkColor: CupertinoColors.systemBlue,
          style: const TextStyle(fontSize: 16),
          linkStyle: const TextStyle(
            fontSize: 14,
          ),
        ),
        if (item.characters.isNotEmpty) ...[
          const DetailsTitle("Characters"),
          DetailsCommonList(
            true,
            item.characters.length,
            null,
            (index) => item.characters[index].image,
            (index) => item.characters[index].name,
            (index) => item.characters[index].role,
            false,
          ),
        ],
        if (item.recommendations.isNotEmpty) ...[
          const DetailsTitle("Recommendations"),
          DetailsRecommendationList(
            item.recommendations.length,
            (index) => item.recommendations[index].imageURL,
            (index) => item.recommendations[index].title,
            (index) => DetailsPage(
              id: item.recommendations[index].malId.toString(),
              contentType: ContentType.anime,
            ),
          ),
        ],
        DetailsReviewSummary(
            item.title.isNotEmpty ? item.title : item.titleOriginal,
            item.reviewSummary,
            item.id,
            null,
            item.malID,
            ContentType.anime.request,
            onRefresh),
        if (item.streaming?.isNotEmpty == true) ...[
          const DetailsTitle("Streaming Platforms"),
          AnimeDetailsStreamingPlatformsList(
            item.streaming!,
          ),
        ],
        if (animeRelations.isNotEmpty) ...[
          const DetailsTitle("Related Anime"),
          ...animeRelations.values.map(
            (animeList) => _RelationListWidget(
              relationList: animeList,
            ),
          ),
        ],
        if (item.producers?.isNotEmpty == true) ...[
          const DetailsTitle("Producers"),
          _buildProducersDisplay(context, item.producers!),
        ],
        if (item.studios?.isNotEmpty == true) ...[
          const DetailsTitle("Studios"),
          DetailsGenreList(
            item.studios!.map((e) => e.name).toList(),
            (studios) => AnimeDiscoverListPage(
              studios: studios,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProducersDisplay(BuildContext context, List<dynamic> producers) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            cupertinoTheme.barBackgroundColor,
            cupertinoTheme.barBackgroundColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cupertinoTheme.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: producers.map((producer) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: cupertinoTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: cupertinoTheme.primaryColor.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: Text(
              producer.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: cupertinoTheme.textTheme.textStyle.color,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GameDetailsContent extends StatelessWidget {
  final GameDetails item;
  final VoidCallback onRefresh;

  const _GameDetailsContent({required this.item, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (item.developers.isNotEmpty) ...[
          const DetailsTitle("Developers"),
          Text(item.developers.join(" • "),
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
        if (item.publishers.isNotEmpty) ...[
          const DetailsTitle("Publishers"),
          DetailsGenreList(
            item.publishers,
            (publisher) => GameDiscoverListPage(
              publisher: publisher,
            ),
          ),
        ],
        const DetailsTitle("Platforms"),
        DetailsGenreList(
          item.platforms,
          (platform) => GameDiscoverListPage(platform: platform),
        ),
        if (item.relatedGames.isNotEmpty) ...[
          const DetailsTitle("Related Games"),
          DetailsRecommendationList(
            isGame: true,
            item.relatedGames.length,
            (index) => item.relatedGames[index].imageURL,
            (index) => item.relatedGames[index].title,
            (index) => DetailsPage(
              id: item.relatedGames[index].rawgId.toString(),
              contentType: ContentType.game,
            ),
          ),
        ],
        DetailsReviewSummary(
            item.title.isNotEmpty ? item.title : item.titleOriginal,
            item.reviewSummary,
            item.id,
            null,
            item.rawgId,
            ContentType.game.request,
            onRefresh),
        if (item.screenshots.isNotEmpty) ...[
          const DetailsTitle("Screenshots"),
          DetailsCarouselSlider(item.screenshots)
        ],
      ],
    );
  }
}

// Helper widgets for better performance
class _PlatformsSection extends StatelessWidget {
  final String Function() countryCode;

  const _PlatformsSection({required this.countryCode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const DetailsTitle("Where to Watch"),
        CupertinoButton(
          child: const Icon(CupertinoIcons.info_circle),
          onPressed: () => showCupertinoDialog(
            context: context,
            builder: (_) => MessageDialog(
              title:
                  "Your Region is ${Country.tryParse(countryCode())?.name ?? countryCode()}",
              "You can change your region from Settings.",
            ),
          ),
        ),
      ],
    );
  }
}

class _RelationListWidget extends StatelessWidget {
  final List<AnimeDetailsRelation> relationList;

  const _RelationListWidget({required this.relationList});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cupertinoTheme.barBackgroundColor,
            cupertinoTheme.barBackgroundColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cupertinoTheme.primaryColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cupertinoTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.link,
                  size: 16,
                  color: cupertinoTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    relationList.first.relation,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cupertinoTheme.primaryColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cupertinoTheme.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${relationList.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cupertinoTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DetailsRecommendationList(
              relationList.length,
              (index) => relationList[index].imageURL,
              (index) => relationList[index].title,
              (index) => DetailsPage(
                id: relationList[index].animeID.toString(),
                contentType: ContentType.anime,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
