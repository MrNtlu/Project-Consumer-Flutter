import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_social_provider.dart';
import 'package:watchlistfy/widgets/common/empty_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_shimmer_cell.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_sort_sheet.dart';
import 'package:watchlistfy/widgets/main/social/social_custom_list_cell.dart';

class CustomListSocialListPage extends StatefulWidget {
  const CustomListSocialListPage({super.key});

  @override
  State<CustomListSocialListPage> createState() => _CustomListSocialListPageState();
}

class _CustomListSocialListPageState extends State<CustomListSocialListPage> {
  ListState _state = ListState.init;

  late final CustomListSocialProvider _provider;
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

    _provider.getCustomList(page: _page).then((response) {
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
    _provider = CustomListSocialProvider();
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
        middle: const Text("🗂️ Lists"),
        trailing: CupertinoButton(
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CustomListSortSheet(
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
        child: Consumer<CustomListSocialProvider>(
          builder: (context, provider, child) {
            return _body(provider.items);
          },
        ),
      ),
    );
  }

  Widget _body(List<CustomList> data) {
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
                  height: 175,
                  child: CustomListShimmerCell()
                ),
              );
            }

            final content = data[index];

            return SizedBox(
              height: 175,
              child: SocialCustomListCell(
                -1, content,
              )
            );
          },
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