import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
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
import 'package:watchlistfy/providers/main/search_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

//TODO Make is nullable
class SearchListPage extends StatefulWidget {
  final String initialSearch;

  const SearchListPage(this.initialSearch, {super.key});

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  ListState _state = ListState.init;
  BannerAd? _bannerAd;

  late final SearchProvider provider;
  late final AuthenticationProvider _authenticationProvider;
  late final ContentProvider _contentProvider;
  late final MovieListProvider _movieListProvider;
  late final TVListProvider _tvListProvider;
  late final AnimeListProvider _animeListProvider;
  late final GameListProvider _gameListProvider;
  late final GlobalProvider _globalProvider;
  late final ScrollController _scrollController;
  TextEditingController? _searchController;

  int _page = 1;
  bool _canPaginate = false;
  bool _isPaginating = false;
  String? _error;
  bool toggleSearch = false;

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
    switch (_contentProvider.selectedContent) {
      case ContentType.movie:
        futureResponse = _movieListProvider.searchMovie(
            page: _page, search: provider.search);
        break;
      case ContentType.tv:
        futureResponse = _tvListProvider.searchTVSeries(
            page: _page, search: provider.search);
        break;
      case ContentType.anime:
        futureResponse = _animeListProvider.searchAnime(
            page: _page, search: provider.search);
        break;
      case ContentType.game:
        futureResponse =
            _gameListProvider.searchGame(page: _page, search: provider.search);
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
              : (response.data.isEmpty && _page == 1
                  ? ListState.empty
                  : ListState.done);
        });
      }
    });
  }

  void _scrollHandler() {
    if (_canPaginate &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent / 2 &&
        !_scrollController.position.outOfRange) {
      _page++;
      _fetchData();
    }
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: kDebugMode
          ? (Platform.isIOS
              ? "ca-app-pub-3940256099942544/2934735716"
              : "ca-app-pub-3940256099942544/6300978111")
          : (Platform.isIOS
              ? dotenv.env['ADMOB_BANNER_IOS_KEY'] ?? ''
              : dotenv.env['ADMOB_BANNER_ANDROID_KEY'] ?? ''),
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
    provider = SearchProvider();
    _movieListProvider = MovieListProvider();
    _tvListProvider = TVListProvider();
    _animeListProvider = AnimeListProvider();
    _gameListProvider = GameListProvider();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _authenticationProvider = Provider.of<AuthenticationProvider>(context);
      _contentProvider = Provider.of<ContentProvider>(context, listen: false);
      _globalProvider = Provider.of<GlobalProvider>(context);
      provider.setSearch(widget.initialSearch);
      _searchController = TextEditingController(text: widget.initialSearch);
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollHandler);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollHandler);
    _state = ListState.disposed;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BaseContent> data;
    switch (_contentProvider.selectedContent) {
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
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _movieListProvider),
        ChangeNotifierProvider(create: (context) => _tvListProvider),
        ChangeNotifierProvider(create: (context) => _animeListProvider),
        ChangeNotifierProvider(create: (context) => _gameListProvider),
      ],
      child: ChangeNotifierProvider(
        create: (_) => provider,
        child: Consumer<SearchProvider>(builder: (context, provider, child) {
          final shouldShowBannerAds = _bannerAd != null &&
              (_authenticationProvider.basicUserInfo == null ||
                  _authenticationProvider.basicUserInfo?.isPremium == false);

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: CupertinoTextField(
                controller: _searchController,
                clearButtonMode: OverlayVisibilityMode.editing,
                suffixMode: OverlayVisibilityMode.notEditing,
                suffix: Icon(CupertinoIcons.search,
                    color: CupertinoTheme.of(context).bgTextColor),
                cursorColor: CupertinoTheme.of(context).bgTextColor,
                decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).onBgColor,
                    borderRadius: BorderRadius.circular(8)),
                maxLines: 1,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                textInputAction: TextInputAction.search,
                placeholder: "Search",
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    provider.setSearch(value);
                    _page = 1;
                    _fetchData();
                  }
                },
              ),
              trailing: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      toggleSearch = !toggleSearch;
                    });
                  },
                  padding: EdgeInsets.zero,
                  child: FaIcon(
                      toggleSearch
                          ? FontAwesomeIcons.barsStaggered
                          : FontAwesomeIcons.bars,
                      size: 24)),
            ),
            child: Column(
              children: [
                if (toggleSearch) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          List.generate(ContentType.values.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 9 : 3, right: 3),
                          child: SizedBox(
                            width: 100,
                            child: CupertinoChip(
                              isSelected: ContentType.values[index] ==
                                  _contentProvider.selectedContent,
                              size: 14,
                              cornerRadius: 8,
                              selectedBGColor:
                                  CupertinoTheme.of(context).profileButton,
                              selectedTextColor: AppColors().primaryColor,
                              onSelected: (_) {
                                _contentProvider
                                    .setContentType(ContentType.values[index]);
                                _page = 1;
                                _fetchData();
                              },
                              label: ContentType.values[index].value,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
                Expanded(child: _body(data)),
                if (shouldShowBannerAds)
                  SafeArea(
                    child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!)),
                  )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _body(List<BaseContent> data) {
    switch (_state) {
      case ListState.done:
        final isGridView =
            _globalProvider.contentMode == Constants.ContentUIModes.first;

        return isGridView
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GridView.builder(
                    itemCount: _canPaginate ? data.length + 2 : data.length,
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 350,
                        childAspectRatio:
                            _contentProvider.selectedContent != ContentType.game
                                ? 2 / 3
                                : 16 / 9,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6),
                    itemBuilder: (context, index) {
                      if ((_canPaginate || _isPaginating) &&
                          index >= data.length) {
                        return AspectRatio(
                          aspectRatio: _contentProvider.selectedContent !=
                                  ContentType.game
                              ? 2 / 3
                              : 16 / 9,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Shimmer.fromColors(
                                  baseColor: CupertinoColors.systemGrey,
                                  highlightColor: CupertinoColors.systemGrey3,
                                  child: Container(
                                    color: CupertinoColors.systemGrey,
                                  ))),
                        );
                      }

                      final content = data[index];

                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(CupertinoPageRoute(builder: (_) {
                              switch (_contentProvider.selectedContent) {
                                case ContentType.movie:
                                  return MovieDetailsPage(content.id);
                                case ContentType.tv:
                                  return TVDetailsPage(content.id);
                                case ContentType.anime:
                                  return AnimeDetailsPage(content.id);
                                case ContentType.game:
                                  return GameDetailsPage(content.id);
                              }
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 2),
                            child:
                                ContentCell(content.imageUrl, content.titleEn),
                          ));
                    }),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ListView.builder(
                  itemCount: _canPaginate ? data.length + 1 : data.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if ((_canPaginate || _isPaginating) &&
                        index >= data.length) {
                      return ContentListShimmerCell(
                          _contentProvider.selectedContent);
                    }

                    final content = data[index];

                    return ContentListCell(_contentProvider.selectedContent,
                        content: content);
                  },
                ),
              );
      case ListState.empty:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/lottie/empty.json",
                    height: MediaQuery.of(context).size.height * 0.5,
                    frameRate: const FrameRate(60)),
                const Text("Couldn't find anything.",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
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
