import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/main/actor/actor_content_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class ActorContentPage extends StatefulWidget {
  final String id;
  final String name;
  final String? image;
  final bool isMovie;

  const ActorContentPage(
    this.id, 
    this.name,
    this.image,
    {this.isMovie = true, super.key}
  );

  @override
  State<ActorContentPage> createState() => _ActorContentPageState();
}

class _ActorContentPageState extends State<ActorContentPage> {
  ListState _state = ListState.init;

  late final ActorContentProvider _provider;
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

    _provider.getContentByActor(
      id: widget.id, 
      isMovie: widget.isMovie,
      page: _page,
    ).then((response) {
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
    _provider = ActorContentProvider();
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.image != null && widget.image!.isNotEmpty)
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                widget.image!,
              )
            ),
            if (widget.image != null && widget.image!.isNotEmpty)
            const SizedBox(width: 6),
            Text(widget.name),
          ],
        ),
      ),
      child: ChangeNotifierProvider(
        create: (_) => _provider,
        child: Consumer<ActorContentProvider>(
          builder: (context, provider, child) {
            return _body(provider.items);
          },
        ),
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
                    if (widget.isMovie) {
                      return MovieDetailsPage(content.id);
                    } else {
                      return TVDetailsPage(content.id);
                    }
                  })
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: ContentCell(content.imageUrl, content.titleEn),
              )
            );
          }
        );
      case ListState.empty:
        return const EmptyView("assets/lottie/empty.json", "Nothing here.");
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
