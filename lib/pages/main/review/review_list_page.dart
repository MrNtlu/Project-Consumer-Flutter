import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/pages/main/review/review_create_page.dart';
import 'package:watchlistfy/providers/main/review/review_list_provider.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/review/review_list_cell.dart';
import 'package:watchlistfy/widgets/main/review/review_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/main/review/review_sort_sheet.dart';

class ReviewListPage extends StatefulWidget {
  final String? title;
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final VoidCallback fetchData;

  const ReviewListPage(
    this.title, this.contentID, this.contentExternalID,
    this.contentExternalIntID, this.contentType, this.fetchData,
    {super.key}
  );

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  ListState _state = ListState.init;

  late final ReviewListProvider _provider;
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

    _provider.getReviews(
      page: _page,
      contentID: widget.contentID,
      contentExternalID: widget.contentExternalID,
      contentExternalIntID: widget.contentExternalIntID,
      contentType: widget.contentType,
    ).then((response) {
      _error = response.error;

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
    _provider = ReviewListProvider();
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
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<ReviewListProvider>(
        builder: (context, provider, child) {
          final data = provider.items;

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: AutoSizeText(
                "💬 ${widget.title ?? ''} Reviews", maxLines: 1, overflow: TextOverflow.ellipsis,
                minFontSize: 13,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return ReviewSortSheet(
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
                  if (data.where((element) => element.isAuthor).isEmpty && _state != ListState.loading)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                        return ReviewCreatePage(
                          widget.contentID, widget.contentExternalID, widget.contentExternalIntID,
                          widget.contentType, widget.fetchData, updateReviewData: _fetchData,
                        );
                      }));
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.add, size: 28)
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

  Widget _body(List<Review> data) {
    switch (_state) {
      case ListState.done:
        return ListView.separated(
          separatorBuilder: (_, __) => const CustomDivider(height: 1, opacity: 0.3),
          itemCount: data.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if ((_canPaginate || _isPaginating) && index >= data.length) {
              return const ReviewListShimmerCell();
            }

            final item = data[index];

            return ReviewListCell(item, widget.fetchData, _fetchData, _provider);
          }
        );
      case ListState.empty:
        return const EmptyView("assets/lottie/review.json", "No reviews yet.");
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