import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';
import 'package:watchlistfy/static/constants.dart';
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

  late final UserListProvider _provider;
  late final UserListContentSelectionProvider _userListProvider;
  late final GlobalProvider _globalProvider;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getUserList(sort: _userListProvider.sort).then((response) {
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
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _globalProvider = Provider.of<GlobalProvider>(context);
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context, 
                        builder: (context) {
                          return UserListSettingsSheet(_fetchData, userListProvider);
                        });
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.sort_down, size: 28)
                  )
                ],
              ),
            ),
            child: _body(userListProvider, provider),
          );
        }
      ),
    );
  }

  Widget _body(UserListContentSelectionProvider provider, UserListProvider userListProvider) {
    switch (_state) {
      case DetailState.view:
        return ListView.builder(
          itemCount: provider.selectedContent == ContentType.movie
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
          ),
          itemBuilder: (context, index) {
            late UserListContent data;

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

            return Padding(
              padding: _globalProvider.userListMode == Constants.UserListUIModes.first
              ? const EdgeInsets.symmetric(horizontal: 3, vertical: 4)
              : const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: data.isLoading
              ? UserListShimmerCell(
                data.imageUrl ?? '',
                data.title, 
                provider.selectedContent,
                data.totalSeasons, 
                data.totalEpisodes
              )
              : GestureDetector(
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
        );
      case DetailState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_error ?? "Unknown error!"),
          ),
        );
      case DetailState.loading:
        return const LoadingView("Fetching data");
      default:
       return const LoadingView("Loading");
    }
  }
}