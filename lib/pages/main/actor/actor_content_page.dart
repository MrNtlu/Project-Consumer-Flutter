import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/image_page.dart';
import 'package:watchlistfy/providers/main/actor/actor_content_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/content_list_cell.dart';
import 'package:watchlistfy/widgets/common/content_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/common/content_list.dart';

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
      _globalProvider = Provider.of<GlobalProvider>(context);
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
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return ImagePage(widget.image!);
                  })
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CachedNetworkImage(
                  imageUrl: widget.image!,
                  key: ValueKey<String>(widget.image!),
                  cacheKey: widget.image,
                  fit: BoxFit.cover,
                  height: 36,
                  width: 36,
                  cacheManager: CustomCacheManager(),
                  maxHeightDiskCache: 100,
                  maxWidthDiskCache: 100,
                )
              ),
            ),
            if (widget.image != null && widget.image!.isNotEmpty)
            const SizedBox(width: 6),
            Text(widget.name),
          ],
        ),
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
        final isGridView = _globalProvider.contentMode == Constants.ContentUIModes.first;

        return isGridView
        ? ContentList(
          _scrollController,
          _canPaginate,
          _isPaginating,
          widget.isMovie,
          data
        )
        : Padding(
          padding: const EdgeInsets.only(left: 3, right: 1),
          child: ListView.builder(
            itemCount: _canPaginate ? data.length + 1 : data.length,
            controller: _scrollController,
            itemBuilder: (context, index) {
              if ((_canPaginate || _isPaginating) && index >= data.length) {
                return ContentListShimmerCell(
                  widget.isMovie ? ContentType.movie : ContentType.tv
                );
              }

              final content = data[index];

              return ContentListCell(
                widget.isMovie ? ContentType.movie : ContentType.tv,
                content: content
              );
            },
          ),
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
        return const LoadingView("Loading");
      default:
       return const LoadingView("Loading");
    }
  }
}
