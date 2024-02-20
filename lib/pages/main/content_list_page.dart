import 'package:flutter/cupertino.dart';
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
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/anime/anime_list_provider.dart';
import 'package:watchlistfy/providers/main/game/game_list_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_list_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_list_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
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

  late final ContentProvider _contentProvider;
  late final MovieListProvider _movieListProvider;
  late final TVListProvider _tvListProvider;
  late final AnimeListProvider _animeListProvider;
  late final GameListProvider _gameListProvider;
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

  @override
  void initState() {
    super.initState();
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
        ),
        child: _body(data)
      ),
    );
  }

  Widget _body(List<BaseContent> data) {
    switch (_state) {
      case ListState.done:
        return GridView.builder(
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
                  }, maintainState: false)
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: ContentCell(content.imageUrl, content.titleEn, cacheWidth: 400, cacheHeight: 600),
              )
            );
          }
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
        return const LoadingView("Fetching data");
      default:
       return const LoadingView("Loading");
    }
  }
}
