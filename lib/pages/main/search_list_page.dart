import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:watchlistfy/pages/details_page.dart';
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
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/search/search_history_list.dart';

class SearchListPage extends StatefulWidget {
  final String? initialSearch;

  const SearchListPage(this.initialSearch, {super.key});

  @override
  State<SearchListPage> createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  ListState _state = ListState.init;
  BannerAd? _bannerAd;

  // Optimize provider creation - create once and reuse
  late final SearchProvider _searchProvider;
  late final MovieListProvider _movieListProvider;
  late final TVListProvider _tvListProvider;
  late final AnimeListProvider _animeListProvider;
  late final GameListProvider _gameListProvider;
  late final ScrollController _scrollController;
  late final CupertinoThemeData _cupertinoTheme;

  // Access providers without creating new instances
  late AuthenticationProvider _authenticationProvider;
  late ContentProvider _contentProvider;
  late GlobalProvider _globalProvider;

  late final TextEditingController _searchController;
  Timer? _debounceTimer;

  int _page = 1;
  bool _canPaginate = false;
  bool _isPaginating = false;
  String? _error;
  bool _toggleSearch = false;
  bool _isSearching = false;

  void _performSearch() {
    // Cancel any pending debounced search
    _debounceTimer?.cancel();

    final searchText = _searchController.text.trim();

    if (searchText.isEmpty) {
      _searchProvider.showSearchHistory();
      setState(() {
        _state = ListState.init;
        _isSearching = false;
      });
      return;
    }

    _searchProvider.setSearch(searchText);
    _page = 1;
    _isSearching = true;
    _fetchData();
  }

  void _fetchData() {
    // Don't fetch if showing search history or search is empty
    if (_searchProvider.isShowingHistory ||
        _searchProvider.search.trim().isEmpty) {
      return;
    }

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
            page: _page, search: _searchProvider.search);
        break;
      case ContentType.tv:
        futureResponse = _tvListProvider.searchTVSeries(
            page: _page, search: _searchProvider.search);
        break;
      case ContentType.anime:
        futureResponse = _animeListProvider.searchAnime(
            page: _page, search: _searchProvider.search);
        break;
      case ContentType.game:
        futureResponse = _gameListProvider.searchGame(
            page: _page, search: _searchProvider.search);
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

  void _handleSearchFieldChange(String value) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Show history immediately when field becomes empty
    if (value.isEmpty) {
      _searchProvider.showSearchHistory();
      setState(() {
        _state = ListState.init;
        _isSearching = false;
      });
    } else {
      // Don't change UI immediately - wait 1 second after user stops typing
      _debounceTimer = Timer(const Duration(seconds: 1), () {
        if (value.trim().isNotEmpty) {
          // Now hide history and show loading
          _searchProvider.hideSearchHistory();
          _searchProvider.setSearch(value.trim());
          _page = 1;
          _isSearching = true;
          _fetchData();
        }
      });
    }
  }

  void _handleHistoryItemTap(String historyItem) {
    // Cancel any pending debounced search
    _debounceTimer?.cancel();

    _searchController.text = historyItem;
    _searchProvider.selectFromHistory(historyItem);
    _page = 1;
    _isSearching = true;
    _fetchData();
  }

  void _handleContentTypeChange(ContentType contentType) {
    _contentProvider.setContentType(contentType);
    _page = 1;

    // Only fetch if we have an active search
    if (_isSearching && _searchProvider.search.isNotEmpty) {
      _fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAd();

    // Optimize: Create providers once
    _searchProvider = SearchProvider();
    _movieListProvider = MovieListProvider();
    _tvListProvider = TVListProvider();
    _animeListProvider = AnimeListProvider();
    _gameListProvider = GameListProvider();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollHandler);
    _searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _authenticationProvider = Provider.of<AuthenticationProvider>(context);
      _contentProvider = Provider.of<ContentProvider>(context, listen: false);
      _globalProvider = Provider.of<GlobalProvider>(context);
      _cupertinoTheme = CupertinoTheme.of(context);

      // Handle initial search
      final initialSearch = widget.initialSearch?.trim();
      if (initialSearch != null && initialSearch.isNotEmpty) {
        _searchController.text = initialSearch;
        _searchProvider.setSearch(initialSearch);
        _isSearching = true;
        _fetchData();
      } else {
        // Show search history if no initial search
        _searchProvider.showSearchHistory();
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollHandler);
    _state = ListState.disposed;

    _scrollController.dispose();
    _searchController.dispose();
    _bannerAd?.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _searchProvider),
        ChangeNotifierProvider.value(value: _movieListProvider),
        ChangeNotifierProvider.value(value: _tvListProvider),
        ChangeNotifierProvider.value(value: _animeListProvider),
        ChangeNotifierProvider.value(value: _gameListProvider),
      ],
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          return CupertinoPageScaffold(
            navigationBar: _buildNavigationBar(context),
            child: _buildBody(searchProvider),
          );
        },
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _searchController,
              clearButtonMode: OverlayVisibilityMode.editing,
              cursorColor: _cupertinoTheme.bgTextColor,
              decoration: BoxDecoration(
                color: _cupertinoTheme.onBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              maxLines: 1,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              textInputAction: TextInputAction.search,
              placeholder: "Search",
              onChanged: _handleSearchFieldChange,
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minSize: 0,
            onPressed: _performSearch,
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              color: _cupertinoTheme.primaryColor,
            ),
          ),
        ],
      ),
      trailing: CupertinoButton(
        onPressed: () {
          setState(() {
            _toggleSearch = !_toggleSearch;
          });
        },
        padding: EdgeInsets.zero,
        child: CircleAvatar(
          backgroundColor: _cupertinoTheme.onBgColor,
          child: FaIcon(
            _toggleSearch
                ? FontAwesomeIcons.barsStaggered
                : FontAwesomeIcons.bars,
            size: 20,
            color: _cupertinoTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SearchProvider searchProvider) {
    final shouldShowBannerAds = _bannerAd != null &&
        (_authenticationProvider.basicUserInfo == null ||
            _authenticationProvider.basicUserInfo?.isPremium == false);

    return Column(
      children: [
        if (_toggleSearch) _buildContentTypeSelector(),
        Expanded(
          child: searchProvider.isShowingHistory
              ? _buildSearchHistoryView(searchProvider)
              : _buildSearchResultsView(),
        ),
        if (shouldShowBannerAds) _buildBannerAd(),
      ],
    );
  }

  Widget _buildContentTypeSelector() {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ContentType.values.length,
              itemBuilder: (context, index) {
                final contentType = ContentType.values[index];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 9 : 3, right: 3),
                  child: SizedBox(
                    width: 100,
                    child: CupertinoChip(
                      isSelected:
                          contentType == contentProvider.selectedContent,
                      size: 14,
                      cornerRadius: 8,
                      selectedBGColor: _cupertinoTheme.profileButton,
                      selectedTextColor: AppColors().primaryColor,
                      onSelected: (_) => _handleContentTypeChange(contentType),
                      label: contentType.value,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBannerAd() {
    return SafeArea(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }

  Widget _buildSearchHistoryView(SearchProvider searchProvider) {
    return SearchHistoryList(
      searchHistory: searchProvider.searchHistory,
      onHistoryItemTap: _handleHistoryItemTap,
      onDeleteHistoryItem: (item) =>
          searchProvider.removeSearchHistoryItem(item),
      onClearAllHistory: () => searchProvider.clearSearchHistory(),
    );
  }

  Widget _buildSearchResultsView() {
    final data = _getCurrentData();
    return _buildResultsBody(data);
  }

  List<BaseContent> _getCurrentData() {
    switch (_contentProvider.selectedContent) {
      case ContentType.movie:
        return _movieListProvider.items;
      case ContentType.tv:
        return _tvListProvider.items;
      case ContentType.anime:
        return _animeListProvider.items;
      case ContentType.game:
        return _gameListProvider.items;
    }
  }

  Widget _buildResultsBody(List<BaseContent> data) {
    switch (_state) {
      case ListState.done:
        final isGridView =
            _globalProvider.contentMode == Constants.ContentUIModes.first;
        return isGridView ? _buildGridView(data) : _buildListView(data);
      case ListState.empty:
        return _buildEmptyState();
      case ListState.error:
        return _buildErrorState();
      case ListState.loading:
        return const LoadingView("Searching");
      default:
        return const LoadingView("Loading");
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/lottie/search.json",
              height: MediaQuery.of(context).size.height * 0.4,
              frameRate: FrameRate(
                RefreshRateHelper().getRefreshRate(),
              ),
            ),
            const Text(
              "No results found.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Try searching for something else",
              style: TextStyle(
                color: CupertinoColors.systemGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 48,
              color: CupertinoColors.systemRed,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? "Something went wrong",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: _performSearch,
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<BaseContent> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GridView.builder(
        itemCount: _canPaginate ? data.length + 2 : data.length,
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          childAspectRatio: _contentProvider.selectedContent != ContentType.game
              ? 2 / 3
              : 16 / 9,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          if ((_canPaginate || _isPaginating) && index >= data.length) {
            return _buildShimmerGridItem();
          }

          final content = data[index];
          return _buildGridItem(content);
        },
      ),
    );
  }

  Widget _buildShimmerGridItem() {
    return AspectRatio(
      aspectRatio:
          _contentProvider.selectedContent != ContentType.game ? 2 / 3 : 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey,
          highlightColor: CupertinoColors.systemGrey3,
          child: Container(
            color: CupertinoColors.systemGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BaseContent content) {
    return GestureDetector(
      onTap: () => _navigateToDetails(content),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
        child: ContentCell(
          content.imageUrl.replaceFirst("original", "w400"),
          content.titleEn,
          cornerRadius:
              _contentProvider.selectedContent == ContentType.game ? 8 : 12,
        ),
      ),
    );
  }

  Widget _buildListView(List<BaseContent> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ListView.builder(
        itemCount: _canPaginate ? data.length + 1 : data.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if ((_canPaginate || _isPaginating) && index >= data.length) {
            return ContentListShimmerCell(_contentProvider.selectedContent);
          }

          final content = data[index];
          return ContentListCell(
            _contentProvider.selectedContent,
            content: content,
          );
        },
      ),
    );
  }

  void _navigateToDetails(BaseContent content) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) {
          return DetailsPage(
            id: content.id,
            contentType: _contentProvider.selectedContent,
          );
        },
      ),
    );
  }
}
