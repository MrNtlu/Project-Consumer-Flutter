import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/main/streaming/streaming_platform_content_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/common/content_list.dart';
import 'package:watchlistfy/widgets/main/common/streaming_sort_sheet.dart';

class StreamingContentPage extends StatefulWidget {
  final String region;
  final String platform;
  final String? image;
  final bool isMovie;
  final bool isAnime;

  const StreamingContentPage(this.region, this.platform, this.image, {this.isMovie = true, this.isAnime = false, super.key});

  @override
  State<StreamingContentPage> createState() => _StreamingContentPageState();
}

class _StreamingContentPageState extends State<StreamingContentPage> {
  ListState _state = ListState.init;

  late final StreamingPlatformContentProvider _provider;
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

    _provider.getContentByStreamingPlatform(
      region: widget.region,
      platform: widget.platform,
      isMovie: widget.isMovie,
      isAnime: widget.isAnime,
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
    _provider = StreamingPlatformContentProvider();
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.image!,
                key: ValueKey<String>(widget.image!),
                cacheKey: widget.image,
                fit: BoxFit.cover,
                height: 32,
                width: 32,
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
                            widget.platform,
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
            if (widget.image != null && widget.image!.isNotEmpty)
            const SizedBox(width: 8),
            Text(widget.platform),
          ],
        ),
        trailing: CupertinoButton(
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return StreamingSortSheet(
                  _provider.sort,
                  (newSort) {
                    final shouldFetchData = _provider.sort != newSort;
                    _provider.sort = newSort;

                    if (shouldFetchData) {
                      _fetchData();
                    }
                  }
                );
              }
            );
          },
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.sort_down, size: 28)
        ),
      ),
      child: ChangeNotifierProvider(
        create: (_) => _provider,
        child: Consumer<StreamingPlatformContentProvider>(
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
        return ContentList(
          _scrollController,
          _canPaginate,
          _isPaginating,
          widget.isMovie,
          isAnime: widget.isAnime,
          data
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