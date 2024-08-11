import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/anime/anime_list_provider.dart';
import 'package:watchlistfy/providers/main/game/game_list_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_list_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_list_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class ContentListPage extends StatefulWidget {
  final ContentType contentType;
  final String contentTag;
  final String title;

  const ContentListPage(this.contentType, this.contentTag, this.title, {super.key});

  @override
  State<ContentListPage> createState() => _ContentListPageState();
}

class _ContentListPageState extends State<ContentListPage> {
  ListState _state = ListState.init;
  BannerAd? _bannerAd;

  late final ContentProvider _contentProvider;
  late final AuthenticationProvider _authenticationProvider;
  late final MovieListProvider _movieListProvider;
  late final TVListProvider _tvListProvider;
  late final AnimeListProvider _animeListProvider;
  late final GameListProvider _gameListProvider;
  late final GlobalProvider _globalProvider;
  late final ScrollController _scrollController;

  int _page = 1;
  bool _canPaginate = false;
  bool _isPaginating = false;
  String? _error;

  void _fetchData() {
    if (_page == 1) {
      setState(() {
        _state = ListState.loading;
      });
    } else {
      _canPaginate = false;
      _isPaginating = true;
    }

    Future<BasePaginationResponse<BaseContent>> futureResponse;
    switch (widget.contentType) {
      case ContentType.movie:
        futureResponse = _movieListProvider.getMovies(page: _page, contentTag: widget.contentTag);
        break;
      case ContentType.tv:
        futureResponse = _tvListProvider.getTVSeries(page: _page, contentTag: widget.contentTag);
        break;
      case ContentType.anime:
        futureResponse = _animeListProvider.getAnime(page: _page, contentTag: widget.contentTag);
        break;
      case ContentType.game:
        futureResponse = _gameListProvider.getGames(page: _page, contentTag: widget.contentTag);
        break;
      default:
        futureResponse = _movieListProvider.getMovies(page: _page, contentTag: widget.contentTag);
        break;
    }

    futureResponse.then((response) {
      _error = response.error;
      _canPaginate = response.canNextPage;
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
      _fetchData();
    }
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: kDebugMode ? (
        Platform.isIOS ? "ca-app-pub-3940256099942544/2934735716" : "ca-app-pub-3940256099942544/6300978111"
      ) : (
        Platform.isIOS ? dotenv.env['ADMOB_BANNER_IOS_KEY'] ?? '': dotenv.env['ADMOB_BANNER_ANDROID_KEY'] ?? ''
      ),
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
    _movieListProvider = MovieListProvider();
    _tvListProvider = TVListProvider();
    _animeListProvider = AnimeListProvider();
    _gameListProvider = GameListProvider();
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
      _contentProvider = Provider.of<ContentProvider>(context, listen: false);
      _globalProvider = Provider.of<GlobalProvider>(context);
      _authenticationProvider = Provider.of<AuthenticationProvider>(context);
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollHandler);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<BaseContent> data;
    switch (widget.contentType) {
      case ContentType.movie:
        data = _movieListProvider.items;
        break;
      case ContentType.tv:
        data = _tvListProvider.items;
        break;
      case ContentType.anime:
        data = _animeListProvider.items;
        break;
      case ContentType.game:
        data = _gameListProvider.items;
        break;
      default:
        data = _movieListProvider.items;
        break;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _movieListProvider),
        ChangeNotifierProvider(create: (context) => _tvListProvider),
        ChangeNotifierProvider(create: (context) => _animeListProvider),
        ChangeNotifierProvider(create: (context) => _gameListProvider),
      ],
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: "Home",
          middle: Text(widget.title),
          trailing: CupertinoButton(
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
        ),
        child: _body(data)
      ),
    );
  }

  Widget _body(List<BaseContent> data) {
    switch (_state) {
      case ListState.done:
        final isGridView = _globalProvider.contentMode == Constants.ContentUIModes.first;
        final shouldShowBannerAds = _bannerAd != null && (_authenticationProvider.basicUserInfo == null || _authenticationProvider.basicUserInfo?.isPremium == false);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: shouldShowBannerAds
          ? Column(
            children: [
              Expanded(
                child: isGridView
                ? _gridList(data)
                : _listView(data)
              ),
              _bannerAds(),
            ],
          )
          : (
            isGridView
            ? _gridList(data)
            : _listView(data)
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

  Widget _gridList(List<BaseContent> data) => GridView.builder(
    itemCount: _canPaginate ? data.length + 2 : data.length,
    controller: _scrollController,
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 350,
      childAspectRatio: _contentProvider.selectedContent != ContentType.game ? 2/3 : 16/9,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6
    ),
    itemBuilder: (context, index) {
      if ((_canPaginate || _isPaginating) && index >= data.length) {
        return AspectRatio(
          aspectRatio: _contentProvider.selectedContent != ContentType.game ? 2/3 : 16/9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Shimmer.fromColors(
              baseColor: CupertinoColors.systemGrey,
              highlightColor: CupertinoColors.systemGrey3,
              child: const ColoredBox(color: CupertinoColors.systemGrey,)
            )
          ),
        );
      }
  
      final content = data[index];
  
      return GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (_) {
              switch (_contentProvider.selectedContent) {
                case ContentType.movie:
                  return MovieDetailsPage(content.id);
                case ContentType.tv:
                  return TVDetailsPage(content.id);
                case ContentType.anime:
                  return AnimeDetailsPage(content.id);
                case ContentType.game:
                  return GameDetailsPage(content.id);
                default:
                  return MovieDetailsPage(content.id);
              }
            }, maintainState: NavigationTracker().shouldMaintainState())
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
          child: ContentCell(content.imageUrl, content.titleEn, cacheWidth: 500, cacheHeight: 700),
        )
      );
    }
  );

  Widget _listView(List<BaseContent> data) => ListView.builder(
    itemCount: _canPaginate ? data.length + 1 : data.length,
    controller: _scrollController,
    itemBuilder: (context, index) {
      if ((_canPaginate || _isPaginating) && index >= data.length) {
        return ContentListShimmerCell(_contentProvider.selectedContent);
      }
  
      final content = data[index];
  
      return ContentListCell(_contentProvider.selectedContent, content: content);
    },
  );

  Widget _bannerAds() => SafeArea(
    child: SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!)
    ),
  );
}
