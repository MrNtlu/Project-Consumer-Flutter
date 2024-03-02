import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/discover/game_discover_sheet.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/providers/main/discover/discover_game_provider.dart';
import 'package:watchlistfy/providers/main/game/game_list_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class GameDiscoverListPage extends StatefulWidget {
  final String? genre;
  final String sort;
  final String? platform;

  const GameDiscoverListPage({
    this.genre,
    this.sort = "popularity",
    this.platform,
    super.key
  });

  @override
  State<GameDiscoverListPage> createState() => _GameDiscoverListPageState();
}

class _GameDiscoverListPageState extends State<GameDiscoverListPage> {
  ListState _state = ListState.init;

  late final GameListProvider _gameListProvider;
  late final DiscoverGameProvider _discoverProvider;
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

    Future<BasePaginationResponse<BaseContent>> futureResponse = _gameListProvider.discoverGames(
      page: _page,
      sort: _discoverProvider.sort,
      genres: _discoverProvider.genre,
      platform: _discoverProvider.platform,
      tba: _discoverProvider.tba,
    );

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

  @override
  void initState() {
    super.initState();
    _gameListProvider = GameListProvider();
    _discoverProvider = DiscoverGameProvider();
    _discoverProvider.genre = widget.genre;
    _discoverProvider.platform = widget.platform;
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
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = _gameListProvider.items;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _gameListProvider),
        ChangeNotifierProvider(create: (_) => _discoverProvider),
      ],
      child: Consumer<DiscoverGameProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(provider.genre != null ? Uri.decodeQueryComponent(provider.genre!) : 'Discover'),
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
                        builder: (context) => GameDiscoverSheet(_fetchData, provider)
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
        ? GridView.builder(
          itemCount: _canPaginate ? data.length + 2 : data.length,
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            childAspectRatio: 16/9,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6
          ),
          itemBuilder: (context, index) {
            if ((_canPaginate || _isPaginating) && index >= data.length) {
              return AspectRatio(
                aspectRatio: 16/9,
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
                    return GameDetailsPage(content.id);
                  }, maintainState: NavigationTracker().shouldMaintainState())
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: ContentCell(content.imageUrl, content.titleEn),
              )
            );
          }
        )
      : ListView.builder(
        itemCount: _canPaginate ? data.length + 1 : data.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if ((_canPaginate || _isPaginating) && index >= data.length) {
            return const ContentListShimmerCell(ContentType.game);
          }

          final content = data[index];

          return ContentListCell(ContentType.game, content: content);
        },
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