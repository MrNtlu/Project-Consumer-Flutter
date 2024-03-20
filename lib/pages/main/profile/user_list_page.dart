import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_compact.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_content_selection.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_expanded.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_settings_sheet.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_shimmer_cell.dart';

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
        builder: (context, userListProvider, provider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: UserListContentSelection(userListProvider),
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
              child: _body(userListProvider, provider)
            ),
          );
        }
      ),
    );
  }

  Widget _body(UserListContentSelectionProvider provider, UserListProvider userListProvider) {
    switch (_state) {
      case DetailState.view:
        final bool isEmpty = _userListProvider.isSearching
        ? _userListProvider.searchList.isEmpty
        : ((provider.selectedContent == ContentType.movie
          ? userListProvider.item?.movieList.isEmpty
          : (
            provider.selectedContent == ContentType.tv
            ? userListProvider.item?.tvList.isEmpty
            : (
              provider.selectedContent == ContentType.anime
              ? userListProvider.item?.animeList.isEmpty
              : userListProvider.item?.gameList.isEmpty
            )
          )) ?? true);

        return Column(
          children: [
            if (toggleSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                          switch (provider.selectedContent) {
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
                          switch (provider.selectedContent) {
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
                          return UserListSettingsSheet(_fetchData, provider);
                        });
                    },
                    padding: EdgeInsets.zero,
                    child: const FaIcon(FontAwesomeIcons.arrowDownAZ, size: 20)
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _userListProvider.isSearching
                ? (isEmpty ? 1 : _userListProvider.searchList.length)
                : (isEmpty ? 1 : (provider.selectedContent == ContentType.movie
                  ? userListProvider.item?.movieList.length
                  : (
                    provider.selectedContent == ContentType.tv
                    ? userListProvider.item?.tvList.length
                    : (
                      provider.selectedContent == ContentType.anime
                      ? userListProvider.item?.animeList.length
                      : (
                        userListProvider.item?.gameList.length ?? 1
                      )
                    )
                  ))),
                itemBuilder: (context, index) {
                  if (isEmpty) {
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
                            const Text("Nothing here.", style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  }

                  late UserListContent data;

                  if (_userListProvider.isSearching) {
                    data = _userListProvider.searchList[index];
                  } else {
                    switch (provider.selectedContent) {
                      case ContentType.movie:
                        data = userListProvider.item!.movieList[index];
                        break;
                      case ContentType.tv:
                        data = userListProvider.item!.tvList[index];
                        break;
                      case ContentType.anime:
                        data = userListProvider.item!.animeList[index];
                        break;
                      default:
                        data = userListProvider.item!.gameList[index];
                        break;
                    }
                  }

                  return Padding(
                    padding: _globalProvider.userListMode == Constants.UserListUIModes.first
                    ? const EdgeInsets.symmetric(horizontal: 3, vertical: 4)
                    : const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    child: data.isLoading
                    ? UserListShimmerCell(
                      data.title,
                      provider.selectedContent,
                      data.totalSeasons,
                      data.totalEpisodes
                    )
                    : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            switch (ContentType.values.where((element) => element.request == provider.selectedContent.request).first) {
                              case ContentType.movie:
                                return MovieDetailsPage(data.contentID);
                              case ContentType.tv:
                                return TVDetailsPage(data.contentID);
                              case ContentType.anime:
                                return AnimeDetailsPage(data.contentID);
                              case ContentType.game:
                                return GameDetailsPage(data.contentID);
                              default:
                                return MovieDetailsPage(data.contentID);
                            }
                          })
                        ).then((value) => _updateData(data));
                      },
                      child: _globalProvider.userListMode == Constants.UserListUIModes.first
                      ? UserListExpanded(
                        data,
                        provider,
                        userListProvider,
                        index,
                        _updateData
                      )
                      : UserListCompact(
                        data,
                        provider,
                        userListProvider,
                        index,
                        _updateData
                      ),
                    ),
                  );
                }
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