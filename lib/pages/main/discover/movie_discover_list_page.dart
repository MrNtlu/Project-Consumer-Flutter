import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:myanilist/services/cache_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_sheet.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/providers/main/discover/discover_movie_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class MovieDiscoverListPage extends StatefulWidget {
  final String? genre;
  final String sort;
  final String? productionCompanies;
  final String? country;
  final String? streaming;
  final String? streamingLogo;
  final String? region;

  const MovieDiscoverListPage({
    this.genre,
    this.sort = "popularity",
    this.productionCompanies,
    this.country,
    this.streaming,
    this.streamingLogo,
    this.region,
    super.key
  });

  @override
  State<MovieDiscoverListPage> createState() => _MovieDiscoverListPageState();
}

class _MovieDiscoverListPageState extends State<MovieDiscoverListPage> {
  ListState _state = ListState.init;

  late final MovieListProvider _movieListProvider;
  late final DiscoverMovieProvider _discoverProvider;
  late final GlobalProvider _globalProvider;
  late final ScrollController _scrollController;

  int _page = 1;
  bool _canPaginate = false;
  bool _isPaginating = false;
  int _totalResults = 0;
  String? _error;

  void _fetchData(bool isResetting) {
    if (isResetting) {
      _page = 1;
    }

    if (_page == 1) {
      _totalResults = 0;
      setState(() {
        _state = ListState.loading;
      });
    } else {
      _canPaginate = false;
      _isPaginating = true;
    }

    late final int? from;
    late final int? to;
    if (_discoverProvider.decade != null) {
      from = int.parse(_discoverProvider.decade!);
      to = from + 10;
    } else {
      from = null;
      to = null;
    }

    Future<BasePaginationResponse<BaseContent>> futureResponse = _movieListProvider.discoverMovies(
      page: _page,
      sort: _discoverProvider.sort,
      genres: _discoverProvider.genre,
      status: _discoverProvider.status,
      productionCompany: _discoverProvider.productionCompanies,
      productionCountry: _discoverProvider.country,
      from: from,
      to: to,
      rating: _discoverProvider.rating,
      streaming: _discoverProvider.streaming,
      streamingRegion: _discoverProvider.streamingRegion
    );

    futureResponse.then((response) {
      _error = response.error;
      _canPaginate = response.canNextPage;
      _totalResults = response.totalResults;
      _isPaginating = false;

      if (_state != ListState.disposed) {
        setState(() {
          _state = response.error != null && _page <= 1
            ? ListState.error
            : (
              response.data.isEmpty && _page == 1
                ? ListState.empty
                : ListState.done
            );
        });
      }
    });
  }

  void _scrollHandler() {
    if (
      _canPaginate
      && _scrollController.offset >= _scrollController.position.maxScrollExtent / 2
      && !_scrollController.position.outOfRange
    ) {
      _page ++;
      _fetchData(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _movieListProvider = MovieListProvider();
    _discoverProvider = DiscoverMovieProvider();
    _discoverProvider.genre = widget.genre;
    _discoverProvider.productionCompanies = widget.productionCompanies;
    _discoverProvider.country = widget.country;
    if (widget.streaming != null && widget.region != null) {
      _discoverProvider.streaming = widget.streaming;
      _discoverProvider.streamingRegion = widget.region!;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollHandler);
    _state = ListState.disposed;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _globalProvider = Provider.of<GlobalProvider>(context);
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollHandler);
      _fetchData(true);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = _movieListProvider.items;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _movieListProvider),
        ChangeNotifierProvider(create: (_) => _discoverProvider),
      ],
      child: Consumer<DiscoverMovieProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: (
                _discoverProvider.streaming != null
                && widget.streaming != null
                && _discoverProvider.streaming == widget.streaming
              )
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.streamingLogo != null && widget.streamingLogo!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.streamingLogo!,
                      key: ValueKey<String>(widget.streamingLogo!),
                      cacheKey: widget.streamingLogo,
                      fit: BoxFit.cover,
                      height: 32,
                      width: 32,
                      cacheManager: CustomCacheManager.instance,
                      maxHeightDiskCache: 100,
                      maxWidthDiskCache: 100,
                      errorWidget: (context, _, __) {
                        return ColoredBox(
                          color: CupertinoTheme.of(context).bgTextColor,
                          child: SizedBox(
                            height: 75,
                            width: 75,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Center(
                                child: AutoSizeText(
                                  widget.streaming!,
                                  minFontSize: 10,
                                  style: TextStyle(
                                    color: CupertinoTheme.of(context).bgColor,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ),
                          ),
                        );
                      },
                    )
                  ),
                  if (widget.streamingLogo != null && widget.streamingLogo!.isNotEmpty)
                  const SizedBox(width: 8),
                  Text(widget.streaming!),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.productionCompanies != null
                    ? provider.productionCompanies!
                    : provider.genre != null
                      ? provider.genre!
                      : 'Discover'
                  ),
                  if (_totalResults > 0 && _state == ListState.done)
                  Text(
                    "$_totalResults Results",
                    style: const TextStyle(
                      fontSize: 11,
                      color: CupertinoColors.systemGrey2
                    ),
                  )
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      _globalProvider.setContentMode(
                        _globalProvider.contentMode == Constants.ContentUIModes.first
                        ? Constants.ContentUIModes.last
                        : Constants.ContentUIModes.first
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(
                      _globalProvider.contentMode == Constants.ContentUIModes.first
                      ? Icons.grid_view_rounded
                      : CupertinoIcons.list_bullet,
                      size: 28
                    )
                  ),

                  GestureDetector(
                    child: const Icon(Icons.filter_alt_rounded),
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => MovieDiscoverSheet(_fetchData, provider)
                      );
                    },
                  ),
                ],
              ),
            ),
            child: _body(data),
          );
        }
      ),
    );
  }

  Widget _body(List<BaseContent> data) {
    switch (_state) {
      case ListState.done:
        final isGridView = _globalProvider.contentMode == Constants.ContentUIModes.first;

        return isGridView
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: GridView.builder(
            itemCount: _canPaginate ? data.length + 2 : data.length,
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              childAspectRatio: 2/3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6
            ),
            itemBuilder: (context, index) {
              if ((_canPaginate || _isPaginating) && index >= data.length) {
                return AspectRatio(
                  aspectRatio: 2/3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Shimmer.fromColors(
                      baseColor: CupertinoColors.systemGrey,
                      highlightColor: CupertinoColors.systemGrey3,
                      child: Container(color: CupertinoColors.systemGrey,)
                    )
                  ),
                );
              }

              final content = data[index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (_) {
                      return MovieDetailsPage(content.id);
                    }, maintainState: NavigationTracker().shouldMaintainState())
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                  child: ContentCell(content.imageUrl, content.titleEn, forceRatio: true),
                )
              );
            }
          ),
        )
      : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: ListView.builder(
          itemCount: _canPaginate ? data.length + 1 : data.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if ((_canPaginate || _isPaginating) && index >= data.length) {
              return const ContentListShimmerCell(ContentType.movie);
            }

            final content = data[index];

            return ContentListCell(ContentType.movie, content: content);
          },
        ),
      );
      case ListState.empty:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text("Couldn't find anything."),
          ),
        );
      case ListState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_error ?? "Unknown error!"),
          ),
        );
      case ListState.loading:
        return const LoadingView("Loading");
      default:
       return const LoadingView("Loading");
    }
  }
}