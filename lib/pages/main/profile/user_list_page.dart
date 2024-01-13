import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/id_body.dart';
import 'package:watchlistfy/models/main/userlist/request/increment_tv_list_body.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_action_sheet.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_content_selection.dart';
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

  /* TODO
  * - [ ] Sheet, change UI and save locally. Sort & Design(Compact, extended)
  * - [ ] UserList view, edit, delete like details page.
  * - [ ] Sort/Search buttons
  * - [ ] Compact and expanded toggle
  * - [ ] Extract widgets
  * - [ ] RefreshPager, if userList changed refresh userlist.
    - https://github.com/MrNtlu/Asset-Manager-Flutter/blob/master/lib/content/providers/subscription/subscription_state.dart
    - https://github.com/MrNtlu/Asset-Manager-Flutter/blob/master/lib/content/pages/subscription/subscription_page.dart
  */

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getUserList(sort: Constants.SortUserListRequests[0].request).then((response) {
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
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = UserListProvider();
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
        ChangeNotifierProvider(create: (_) => UserListContentSelectionProvider()),
      ],
      child: Consumer2<UserListContentSelectionProvider, UserListProvider>(
        builder: (context, provider, userListProvider, child) {    
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: UserListContentSelection(provider),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      //TODO change view
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.list_bullet_below_rectangle, size: 28)
                  ),
                  CupertinoButton(
                    onPressed: () {
                      //TODO change sort
                    },
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.sort_down, size: 28)
                  )
                ],
              ),
            ),
            child: _body(provider, userListProvider),
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
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
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
                child: Row(
                  children: [
                    SizedBox(
                      width: 3,
                      height: 125,
                      child: ColoredBox(
                        color: data.status == Constants.UserListStatus[0].request
                        ? Colors.green.shade600
                        : data.status == Constants.UserListStatus[1].request
                          ? CupertinoColors.activeBlue
                          : CupertinoColors.systemRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 125,
                      child: ContentCell(data.imageUrl ?? '', data.title)
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AutoSizeText(
                                    data.title,
                                    minFontSize: 14,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    wrapWords: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: const Icon(CupertinoIcons.ellipsis_vertical),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                      context: context, 
                                      builder: (context) {
                                        return UserListActionSheet(
                                          index, 
                                          data.id, 
                                          data.title, 
                                          provider.selectedContent, 
                                          userListProvider, 
                                          () {
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
                                            ).then((value) => _fetchData());
                                          }
                                        );
                                      }
                                    );
                                  }
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (data.totalEpisodes ?? (
                                data.status == Constants.UserListStatus[1].request
                                ? 100
                                : 0
                              )).toDouble() / 100,
                              minHeight: 6,
                              backgroundColor: CupertinoTheme.of(context).onBgColor,
                              color: AppColors().primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow, size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  data.score?.toString() ?? "*",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  Constants.UserListStatus.where((element) => data.status == element.request).first.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if(
                                  data.status == Constants.UserListStatus[0].request &&
                                  provider.selectedContent == ContentType.tv
                                )
                                CupertinoButton(
                                  onPressed: () {
                                    userListProvider.incrementUserList(index, IncrementTVListBody(data.id, false), ContentType.tv);
                                  },
                                  padding: EdgeInsets.zero,
                                  minSize: 16,
                                  child: Icon(
                                    CupertinoIcons.add_circled_solid, 
                                    color: AppColors().primaryColor,
                                    size: 16,
                                  ),
                                ),
                                if(
                                  data.status == Constants.UserListStatus[0].request &&
                                  provider.selectedContent == ContentType.tv
                                )
                                const SizedBox(width: 6),
                                if(provider.selectedContent == ContentType.tv)
                                Text(
                                  data.watchedSeasons?.toString() ?? "?",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if(provider.selectedContent == ContentType.tv)
                                Text("/${data.totalSeasons ?? "?"} seas"),
                                const Spacer(),
                                if(
                                  data.status == Constants.UserListStatus[0].request &&
                                  provider.selectedContent != ContentType.movie
                                )
                                CupertinoButton(
                                  onPressed: () {
                                    switch (provider.selectedContent) {
                                      case ContentType.tv:
                                        userListProvider.incrementUserList(index, IncrementTVListBody(data.id, true), ContentType.tv);
                                        break;
                                      default:
                                        userListProvider.incrementUserList(index, IDBody(data.id), provider.selectedContent);
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  minSize: 16,
                                  child: Icon(
                                    CupertinoIcons.add_circled_solid, 
                                    color: AppColors().primaryColor,
                                    size: 16,
                                  ),
                                ),
                                if(
                                  data.status == Constants.UserListStatus[0].request &&
                                  provider.selectedContent != ContentType.movie
                                )
                                const SizedBox(width: 6),
                                if(
                                  provider.selectedContent != ContentType.movie
                                )
                                Text(
                                  data.watchedEpisodes?.toString() ?? "?",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if(
                                  provider.selectedContent != ContentType.movie
                                )
                                Text("/${data.totalEpisodes ?? "?"} eps"),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
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