import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_sheet.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/providers/main/discover/discover_movie_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class MovieDiscoverListPage extends StatefulWidget {
  final String? genre;
  final String sort;
  final String? productionCompanies;

  const MovieDiscoverListPage({
    this.genre,
    this.sort = "popularity",
    this.productionCompanies,
    super.key
  });

  @override
  State<MovieDiscoverListPage> createState() => _MovieDiscoverListPageState();
}

class _MovieDiscoverListPageState extends State<MovieDiscoverListPage> {
  ListState _state = ListState.init;

  late final MovieListProvider _movieListProvider;
  late final DiscoverMovieProvider _discoverProvider;
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
      from: from,
      to: to,
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
    _movieListProvider = MovieListProvider();
    _discoverProvider = DiscoverMovieProvider();
    _discoverProvider.genre = widget.genre;
    _discoverProvider.productionCompanies = widget.productionCompanies;
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
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollHandler);
      _fetchData();
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
              middle: Text(provider.genre ?? 'Discover'),
              trailing: GestureDetector(
                child: Icon(Icons.filter_alt_rounded, color: CupertinoTheme.of(context).bgTextColor,),
                onTap: () {
                  showCupertinoModalBottomSheet(
                    context: context, 
                    builder: (context) => MovieDiscoverSheet(_fetchData, provider)
                  );
                },
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
        return GridView.builder(
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
                  })
                );
              },
              child: ContentCell(content.imageUrl, content.titleEn)
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