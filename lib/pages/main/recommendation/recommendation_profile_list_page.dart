import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/recommendation/recommendation.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/recommendation/recommendation_list_provider.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/review/review_sort_sheet.dart';
import 'package:watchlistfy/widgets/main/social/social_recommendation_cell.dart';
import 'package:watchlistfy/widgets/main/social/social_recommendation_loading.dart';

class RecommendationProfileListPage extends StatefulWidget {
  const RecommendationProfileListPage({super.key});

  @override
  State<RecommendationProfileListPage> createState() => _RecommendationProfileListPageState();
}

class _RecommendationProfileListPageState extends State<RecommendationProfileListPage> {
  ListState _state = ListState.init;

  late final RecommendationListProvider _provider;
  late final AuthenticationProvider _authProvider;
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

    _provider.getUserRecommendations(
      page: _page,
      userID: _authProvider.basicUserInfo?.id ?? '',
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
    _provider = RecommendationListProvider();
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
      _authProvider = Provider.of<AuthenticationProvider>(context);
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
      child: Consumer<RecommendationListProvider>(
        builder: (context, provider, _) {
          final data = provider.items;

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("💡 My Recommendations"),
              trailing: CupertinoButton(
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
            ),
            child: _body(data),
          );
        }
      ),
    );
  }

  Widget _body(List<RecommendationWithContent> data) {
    switch (_state) {
      case ListState.done:
        return ListView.separated(
          separatorBuilder: (_, __) => const CustomDivider(height: 1, opacity: 0.3),
          itemCount: data.isEmpty
          ? 1
          : _canPaginate ? data.length + 1 : data.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (data.isEmpty) {
              return const EmptyView("assets/lottie/recommendations.json", "No recommendations yet.");
            }

            if ((_canPaginate || _isPaginating) && index >= data.length) {
              return const SocialRecommendationLoading();
            }

            final item = data[index];

            return SocialRecommendationCell(item, isProfile:  true);
          }
        );
      case ListState.empty:
        return const EmptyView("assets/lottie/recommendations.json", "No recommendations yet.");
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