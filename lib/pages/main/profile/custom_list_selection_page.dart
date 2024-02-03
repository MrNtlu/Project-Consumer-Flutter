import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_create_provider.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_search_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/profile/custom_list_entry_cell.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_content_selection.dart';

class CustomListSelectionPage extends StatefulWidget {
  const CustomListSelectionPage({super.key});

  @override
  State<CustomListSelectionPage> createState() => _CustomListSelectionPageState();
}

class _CustomListSelectionPageState extends State<CustomListSelectionPage> {
  ListState _state = ListState.init;

  late final ScrollController _scrollController;
  late final UserListContentSelectionProvider _provider;
  late final CustomListSearchProvider _searchProvider;
  late final CustomListCreateProvider _customListCreateProvider;
  late final AuthenticationProvider authProvider;
  late final TextEditingController searchController;

  int _page = 1;
  bool _canPaginate = false;
  bool _isPaginating = false;
  String? _error;
  
  //TODO Add Remove button

  void _search() {
    if (_page == 1) {
      setState(() {
        _state = ListState.loading;  
      });
    } else {
      _canPaginate = false;
      _isPaginating = true;
    }

    _searchProvider.searchContent(
      selectedContent: _provider.selectedContent,
      search: searchController.value.text,
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
      _search();
    }
  }

  @override
  void initState() {
    super.initState();
    _provider = UserListContentSelectionProvider();
    _searchProvider = CustomListSearchProvider();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      authProvider = Provider.of<AuthenticationProvider>(context);
      _customListCreateProvider = Provider.of<CustomListCreateProvider>(context);
      searchController = TextEditingController();
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollHandler);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _provider),
        ChangeNotifierProvider(create: (_) => _searchProvider),
      ],
      child: Consumer2<UserListContentSelectionProvider, CustomListSearchProvider>(
        builder: (context, provider, searchProvider, _) {

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("🔍 Search"),
              trailing: Text("${_customListCreateProvider.selectedContent.length}/${authProvider.basicUserInfo?.isPremium == true ? "25" : "10"}"),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: CupertinoSearchTextField(
                          controller: searchController,
                          suffixMode: OverlayVisibilityMode.always,
                          suffixIcon: const Icon(CupertinoIcons.search_circle_fill, color: CupertinoColors.systemBlue),
                          onSuffixTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (searchController.value.text.isNotEmpty) {
                              _search();
                            }
                          },
                          onSubmitted: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                        
                            if (value.isNotEmpty) {
                              _search();
                            }
                          },
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      UserListContentSelection(provider),
                    ],
                  ),
                ),
                Expanded(child: _body(searchProvider.items))
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _body(List<BaseContent> data) {
    switch (_state) {
      case ListState.done:
        return ListView.builder(
          itemCount: _canPaginate ? data.length + 1 : data.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            if ((_canPaginate || _isPaginating) && index >= data.length) {
              return const SizedBox(
                height: 150,
                child: LoadingView("Fetching data"),
              );
            }

            final content = data[index];
            final limit = authProvider.basicUserInfo?.isPremium == true ? 25 : 10;
            final doesContain = _customListCreateProvider.doesContain(content.id);

            return CustomListEntryCell(
              _provider.selectedContent, 
              content, 
              doesContain, 
              () {
                _customListCreateProvider.removeContent(content.id);
              }, 
              () {
                if (_customListCreateProvider.selectedContent.length < limit) {  
                  _customListCreateProvider.addNewContent(
                    CustomListContent(
                      0, 
                      content.id, 
                      content.externalId, 
                      content.externalIntId, 
                      _provider.selectedContent.request, 
                      content.titleEn, 
                      content.titleOriginal, 
                      content.imageUrl,
                      null
                    )
                  );
                } else {
                  showCupertinoDialog(
                    context: context, 
                    builder: (_) => const ErrorDialog("You've reached the limit.\nFree users can add up to 10 entries, Premium users can add up to 25 entries.")
                  );
                }
              }
            );
          }
        );
      case ListState.empty:
        return Center(
          child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                "assets/lottie/empty.json",
                height: MediaQuery.of(context).size.height * 0.5,
                frameRate: FrameRate(60)
              ),
              const Text("Couldn't find anything.", style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
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
       return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text("Search and find content that you're looking for!"),
        ),
      );
    }
  }
}