import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/game/game_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';
import 'package:watchlistfy/widgets/common/user_list_view_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_main_info.dart';
import 'package:watchlistfy/widgets/main/common/details_navigation_bar.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

class GameDetailsPage extends StatefulWidget {
  final String id;

  const GameDetailsPage(this.id, {super.key});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  DetailState _state = DetailState.init;

  late final GameDetailsProvider _provider;
  late final AuthenticationProvider _authProvider;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getGameDetails(widget.id).then((response) {
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

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _authProvider = Provider.of<AuthenticationProvider>(context);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = GameDetailsProvider();
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<GameDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                DetailsNavigationBar(
                  "", // _provider.item?.title ?? "",
                  _provider.item == null,
                  _provider.item?.userList == null,
                  _provider.item?.consumeLater == null,
                  provider.isUserListLoading,
                  provider.isLoading,
                  onBookmarkTap: () {
                    if (!provider.isLoading && _authProvider.isAuthenticated) {
                      final item = provider.item;

                      if (item != null && item.consumeLater != null) {
                        provider.deleteConsumeLaterObject(IDBody(item.consumeLater!.id)).then((response) {
                          if (response.error != null) {
                            showCupertinoDialog(
                              context: context, 
                              builder: (_) => ErrorDialog(response.error!),
                            );
                          }
                        });
                      } else if (item != null) {
                        // provider.createConsumeLaterObject(
                        //   ConsumeLaterBody(item.id, item.malID.toString(), "anime")
                        // ).then((response) {
                        //   if (response.error != null) {
                        //     showCupertinoDialog(
                        //       context: context, 
                        //       builder: (_) => ErrorDialog(response.error!),
                        //     );
                        //   }
                        // });
                      }
                    } else if (!_authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => const UnauthorizedDialog()
                      );
                    }
                  },
                  onListTap: () {
                    if (!provider.isUserListLoading && _authProvider.isAuthenticated) {
                      final item = provider.item;

                      if (item != null && item.userList != null) {
                        final status = Constants.UserListStatus.firstWhere((element) => element.request == item.userList!.status).name;
                        final score = item.userList!.score ?? 'Not Scored';
                        final hoursPlayed = item.userList!.watchedEpisodes ?? "?";
                        final timesFinished = item.userList!.timesFinished;

                        showCupertinoModalPopup(
                          context: context, 
                          builder: (context) {
                            return UserListViewSheet(
                              _provider.item!.id, 
                              _provider.item!.title,
                              "🎯 $status\n⭐ $score\n🏁 $timesFinished time(s)\n📺 $hoursPlayed hrs.",
                              _provider.item!.userList!,
                              externalIntID: _provider.item!.rawgId,
                              contentType: ContentType.game,
                              gameProvider: provider,
                            );
                          }
                        );
                      } else if (item != null) {
                        // showCupertinoModalPopup(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (context) {
                        //     return TVWatchListSheet(
                        //       _provider, 
                        //       _provider.item!.id, 
                        //       _provider.item!.tmdbID,
                        //       episodePrefix: _provider.item?.totalEpisodes,
                        //       seasonPrefix: _provider.item?.totalSeasons,
                        //     );
                        //   }
                        // );
                      }
                    } else if (!_authProvider.isAuthenticated) {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) => const UnauthorizedDialog()
                      );
                    }
                  }
                ),
                _body(provider)
              ],
            )
          );
        },
      ),
    );
  }

  Widget _body(GameDetailsProvider provider) {
    switch (_state) {
      case DetailState.view:
        final item = provider.item!;
      
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            DetailsMainInfo(
                              item.rawgRating.toStringAsFixed(2),
                              item.tba ? "TBA" : (item.releaseDate ?? ''),
                            ),
                            const SizedBox(height: 32,),
                            //TODO Info columns
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 125,
                      child: ContentCell(item.imageUrl, item.title)
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                const CustomDivider(height: 0.75, opacity: 0.35),
                const DetailsTitle("Genres"),
                Text( //TODO Change to chip design
                  item.genres.isNotEmpty ? item.genres.join(", ") : "",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                //TODO Image list with slider
                //TODO Review Summary!
                const SizedBox(height: 16)
              ],
            ),
          ),
        );
      case DetailState.error:
        return SliverFillRemaining(child: ErrorView(_error ?? "Unknown error", _fetchData));
      case DetailState.loading:
        return const SliverFillRemaining(child: LoadingView("Please wait"));
      default:
        return const SliverFillRemaining(child: LoadingView("Loading"));
    }
  }
}
