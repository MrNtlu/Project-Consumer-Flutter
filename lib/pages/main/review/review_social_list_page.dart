import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';
import 'package:watchlistfy/providers/main/review/review_social_list_provider.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/review/review_sort_sheet.dart';
import 'package:watchlistfy/widgets/main/review/review_with_content_shimmer_cell.dart';
import 'package:watchlistfy/widgets/main/social/social_review_cell.dart';

class ReviewSocialListPage extends StatefulWidget {
  const ReviewSocialListPage({super.key});

  @override
  State<ReviewSocialListPage> createState() => _ReviewSocialListPageState();
}

class _ReviewSocialListPageState extends State<ReviewSocialListPage> {
  ListState _state = ListState.init;

  late final ReviewSocialListProvider _reviewProvider;
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

    _reviewProvider.getReviews(page: _page).then((response) {
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
    _reviewProvider = ReviewSocialListProvider();
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
        middle: const Text("💬 Reviews"),
        trailing: CupertinoButton(
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return ReviewSortSheet(
                  _reviewProvider.sort,
                  (newSort) {
                    final shouldFetchData = _reviewProvider.sort != newSort;
                    _reviewProvider.sort = newSort;

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
        create: (_) => _reviewProvider,
        child: Consumer<ReviewSocialListProvider>(
          builder: (context, provider, child) {
            return _body(provider.items);
          },
        ),
      ),
    );
  }

  Widget _body(List<ReviewWithContent> data) {
    switch (_state) {
      case ListState.done:
        return ListView.builder(
          itemCount: _canPaginate ? data.length + 1 : data.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if ((_canPaginate || _isPaginating) && index >= data.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: SizedBox(
                  height: 205,
                  child: ReviewWithContentShimmerCell()
                ),
              );
            }

            final content = data[index];

            return SizedBox(
              height: 205,
              child: SocialReviewCell(index, content, _reviewProvider.likeReview)
            );
          },
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