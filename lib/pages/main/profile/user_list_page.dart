import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_grid_view.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_list_view.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_settings_sheet.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  DetailState _state = DetailState.init;
  String? _error;
  bool toggleSearch = false;

  TextEditingController? searchController;
  late final UserListProvider _provider;
  late final UserListContentSelectionProvider _userListProvider;
  late final GlobalProvider _globalProvider;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getUserList(sort: _userListProvider.sort).then((response) async {
      _error = response.error;

      if (_state != DetailState.disposed) {
        setState(() {
          _state = response.error != null
            ? DetailState.error
            : (
              response.data != null
                ? DetailState.view
                : DetailState.error
            );
        });

        try {
          if (!SharedPref().getIsAskedForReview() && response.data != null && (response.data!.animeList.length + response.data!.movieList.length + response.data!.tvList.length + response.data!.gameList.length) > 10) {
            final InAppReview inAppReview = InAppReview.instance;

            if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
                SharedPref().setIsAskedForReview(true);
            }
          }
        } catch(_) {}
      }
    });
  }

  void _updateData(UserListContent content) {
    content.isLoading = true;

    _provider.getUserList(sort: Constants.SortUserListRequests[0].request).then((response) {
      _error = response.error;

      if (_state != DetailState.disposed) {
        content.isLoading = false;
      }
    });
  }

  @override
  void didChangeDependencies() async {
    if (_state == DetailState.init) {
      searchController = TextEditingController();

      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        Navigator.pop(context);
      }

      _globalProvider = Provider.of<GlobalProvider>(context);
      _userListProvider.initContentType(_globalProvider.contentType);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = UserListProvider();
    _userListProvider = UserListContentSelectionProvider();
    if (_state != DetailState.init) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _provider),
        ChangeNotifierProvider(create: (_) => _userListProvider),
      ],
      child: Consumer2<UserListContentSelectionProvider, UserListProvider>(
        builder: (context, userListContentSelectionProvider, userListProvider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("My List"),
              //UserListContentSelection(userListContentSelectionProvider),
              trailing: CupertinoButton(
                onPressed: () {
                  setState(() {
                    toggleSearch = !toggleSearch;
                  });
                },
                padding: EdgeInsets.zero,
                child: FaIcon(toggleSearch ? FontAwesomeIcons.barsStaggered : FontAwesomeIcons.bars, size: 24)
              ),
            ),
            child: RefreshIndicator(
              backgroundColor: CupertinoTheme.of(context).bgTextColor,
              color: CupertinoTheme.of(context).bgColor,
              onRefresh: () async {
                if (_state == DetailState.view || _state == DetailState.error) {
                  _fetchData();
                }
              },
              child: _body(userListContentSelectionProvider, userListProvider)
            ),
          );
        }
      ),
    );
  }

  Widget _body(UserListContentSelectionProvider userListContentSelectionProvider, UserListProvider userListProvider) {
    switch (_state) {
      case DetailState.view:
        // Is Empty Value
        final bool isEmpty = _userListProvider.isSearching
        ? _userListProvider.searchList.isEmpty
        : ((userListContentSelectionProvider.selectedContent == ContentType.movie
          ? userListProvider.item?.movieList.isEmpty
          : (
            userListContentSelectionProvider.selectedContent == ContentType.tv
            ? userListProvider.item?.tvList.isEmpty
            : (
              userListContentSelectionProvider.selectedContent == ContentType.anime
              ? userListProvider.item?.animeList.isEmpty
              : userListProvider.item?.gameList.isEmpty
            )
          )) ?? true);

        // List length
        final length = userListContentSelectionProvider.selectedContent == ContentType.movie
        ? userListProvider.item?.movieList.length
        : (
          userListContentSelectionProvider.selectedContent == ContentType.tv
          ? userListProvider.item?.tvList.length
          : (
            userListContentSelectionProvider.selectedContent == ContentType.anime
            ? userListProvider.item?.animeList.length
            : (
              userListProvider.item?.gameList.length ?? 1
            )
          )
        );

        // User Content List data
        late List<UserListContent> dataList;
        if (_userListProvider.isSearching) {
          dataList = _userListProvider.searchList;
        } else {
          switch (userListContentSelectionProvider.selectedContent) {
            case ContentType.movie:
              dataList = userListProvider.item!.movieList;
              break;
            case ContentType.tv:
              dataList = userListProvider.item!.tvList;
              break;
            case ContentType.anime:
              dataList = userListProvider.item!.animeList;
              break;
            default:
              dataList = userListProvider.item!.gameList;
              break;
          }
        }

        final isGridView = _globalProvider.userListMode == Constants.UserListUIModes.last;

        return Column(
          children: [
            if (toggleSearch)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        ContentType.values.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 9 : 3, right: 3),
                            child: CupertinoChip(
                              // key: [index],
                              isSelected: ContentType.values[index] == userListContentSelectionProvider.selectedContent,
                              size: 16,
                              leading: FaIcon(
                                ContentType.values.map((e) => e.icon).toList()[index],
                                color: ContentType.values[index] == userListContentSelectionProvider.selectedContent
                                ? CupertinoColors.white
                                : AppColors().primaryColor
                              ),
                              onSelected: (_) {
                                userListContentSelectionProvider.setContentType(ContentType.values[index]);
                                // tabProvider.setNewIndex(index);
                                // if (_scrollController.hasClients && socialTabKeys[index].currentContext != null) {
                                //   Scrollable.ensureVisible(socialTabKeys[index].currentContext!);
                                // }
                              },
                              label: ContentType.values[index].value,
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoSearchTextField(
                            controller: searchController,
                            onChanged: (value) {
                              if (_userListProvider.isSearching != value.isNotEmpty) {
                                _userListProvider.setSearching(value.isNotEmpty);
                              }

                              if (value.isNotEmpty) {
                                final List<UserListContent> data;
                                switch (userListContentSelectionProvider.selectedContent) {
                                  case ContentType.movie:
                                    data = userListProvider.item!.movieList;
                                    break;
                                  case ContentType.tv:
                                    data = userListProvider.item!.tvList;
                                    break;
                                  case ContentType.anime:
                                    data = userListProvider.item!.animeList;
                                    break;
                                  default:
                                    data = userListProvider.item!.gameList;
                                    break;
                                }

                                _userListProvider.search(value, data);
                              }
                            },
                            onSuffixTap: () {
                              _userListProvider.setSearching(false);
                              searchController?.clear();
                            },
                            onSubmitted: (value) {
                              _userListProvider.setSearching(value.isNotEmpty);

                              if (value.isNotEmpty) {
                                final List<UserListContent> data;
                                switch (userListContentSelectionProvider.selectedContent) {
                                  case ContentType.movie:
                                    data = userListProvider.item!.movieList;
                                    break;
                                  case ContentType.tv:
                                    data = userListProvider.item!.tvList;
                                    break;
                                  case ContentType.anime:
                                    data = userListProvider.item!.animeList;
                                    break;
                                  default:
                                    data = userListProvider.item!.gameList;
                                    break;
                                }

                                _userListProvider.search(value, data);
                              }
                            },
                          ),
                        ),
                        CupertinoButton(
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return UserListSettingsSheet(_fetchData, userListContentSelectionProvider);
                              });
                          },
                          padding: EdgeInsets.zero,
                          child: const FaIcon(FontAwesomeIcons.arrowDownAZ, size: 20)
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isGridView
              ? UserListGridView(
                isEmpty,
                length,
                dataList,
                userListContentSelectionProvider,
              )
              : UserListListView(
                isEmpty,
                length,
                dataList,
                userListContentSelectionProvider,
                userListProvider,
                _globalProvider,
                _updateData,
              ),
            ),
          ],
        );
      case DetailState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_error ?? "Unknown error!"),
          ),
        );
      case DetailState.loading:
        return const LoadingView("Loading");
      default:
       return const LoadingView("Loading");
    }
  }
}