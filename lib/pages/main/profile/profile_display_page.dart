import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/main/profile/profile_display_details_provider.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/see_all_title.dart';
import 'package:watchlistfy/widgets/main/profile/profile_custom_list_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_extra_info_text.dart';
import 'package:watchlistfy/widgets/main/profile/profile_info_text.dart';
import 'package:watchlistfy/widgets/main/profile/profile_legend_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_level_bar.dart';
import 'package:watchlistfy/widgets/main/profile/profile_review_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_user_image.dart';

class ProfileDisplayPage extends StatefulWidget {
  final String username;

  const ProfileDisplayPage(this.username, {super.key});

  @override
  State<ProfileDisplayPage> createState() => _ProfileDisplayPageState();
}

class _ProfileDisplayPageState extends State<ProfileDisplayPage> {
  DetailState _state = DetailState.init;
  String? _error;

  late final ProfileDisplayDetailsProvider _provider;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getProfileDetails(widget.username).then((response) {
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
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = ProfileDisplayDetailsProvider();
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
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<ProfileDisplayDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: AutoSizeText(
                _provider.item?.username ?? "Profile",
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                _body(provider)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _body(ProfileDisplayDetailsProvider provider) {
    switch (_state) {
      case DetailState.view:
        final item = provider.item!;
        final image = item.image;

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileUserImage(image),
              ProfileLevelBar(item.level),
              //TODO Friend request button
              // const SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       ProfileButton("Custom Lists", () {
              //         Navigator.of(context, rootNavigator: true).push(
              //           CupertinoPageRoute(builder: (_) {
              //             return const CustomListPage();
              //           })
              //         );
              //       }, CupertinoIcons.folder_fill),
              //       const SizedBox(width: 12),
              //       ProfileButton("User List", () {
              //         Navigator.of(context, rootNavigator: true).push(
              //           CupertinoPageRoute(builder: (_) {
              //             return const UserListPage();
              //           })
              //         ).then((value) => _fetchData());
              //       }, CupertinoIcons.list_bullet),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileInfoText(item.movieCount.toString(), "Movies"),
                    ProfileInfoText(item.tvCount.toString(), "TV Series"),
                    ProfileInfoText(item.animeCount.toString(), "Anime"),
                    ProfileInfoText(item.gameCount.toString(), "Games"),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileExtraInfoText((item.movieWatchedTime / 60).round().toString(), "hrs", "Watched"),
                    ProfileExtraInfoText(item.tvWatchedEpisodes.toString(), "eps", "Watched"),
                    ProfileExtraInfoText(item.animeWatchedEpisodes.toString(), "eps", "Watched"),
                    ProfileExtraInfoText(item.gameTotalHoursPlayed.toString(), "hrs", "Played"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("🥇️ Legend Content", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                    CupertinoButton(
                      minSize: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context, 
                          builder: (_) => const MessageDialog(title: "Information", "Legend content refers to movies, animes, games and tv series that users have watched and enjoyed multiple times.")
                        );
                      },
                      child: const Icon(CupertinoIcons.info_circle)
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: item.legendContent.isEmpty ? Axis.vertical : Axis.horizontal,
                  physics: item.watchLater.isEmpty ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  itemCount: item.legendContent.isEmpty ? 1 : item.legendContent.length,
                  itemExtent: 200 * 2 / 3,
                  itemBuilder: (context, index) {
                    if (item.legendContent.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Nothing here."),
                        ),
                      );
                    } else {
                      final data = item.legendContent[index];
          
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(builder: (_) {
                                switch (ContentType.values.where((element) => element.request == data.contentType).first) {
                                  case ContentType.movie:
                                    return MovieDetailsPage(data.id);
                                  case ContentType.tv:
                                    return TVDetailsPage(data.id);
                                  case ContentType.anime:
                                    return AnimeDetailsPage(data.id);
                                  case ContentType.game: 
                                    return GameDetailsPage(data.id);
                                  default:
                                    return MovieDetailsPage(data.id);
                                }
                              })
                            );
                          },
                          child: ProfileLegendCell(
                            data.imageUrl, data.titleEn,
                            timesFinished: data.timesFinished,
                            hoursPlayed: data.hoursPlayed,
                          )
                        ),
                      );
                    }
                  },
                ),
              ),
              SeeAllTitle("💬 Reviews", (){}, shouldHideSeeAllButton: true),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: item.reviews.isEmpty ? Axis.vertical : Axis.horizontal,
                  physics: item.reviews.isEmpty ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  itemCount: item.reviews.isEmpty ? 1 : item.reviews.length,
                  itemExtent: 300,
                  itemBuilder: (context, index) {
                    if (item.reviews.isEmpty) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 64),
                          child: Text("Nothing here."),
                        ),
                      );
                    } else {
                      final data = item.reviews[index];
          
                      return ProfileReviewCell(data, _fetchData);
                    }
                  },
                ),
              ),
              SeeAllTitle("🗂️ Lists", (){}, shouldHideSeeAllButton: true),
              SizedBox(
                height: 125,
                child: ListView.builder(
                  scrollDirection: item.customLists.isEmpty ? Axis.vertical : Axis.horizontal,
                  physics: item.customLists.isEmpty ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  itemCount: item.customLists.isEmpty ? 1 : item.customLists.length,
                  itemExtent: 300,
                  itemBuilder: (context, index) {
                    if (item.customLists.isEmpty) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 64),
                          child: Text("Nothing here."),
                        ),
                      );
                    } else {
                      final data = item.customLists[index];
          
                      return ProfileCustomListCell(data);
                    }
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16)
            ],
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