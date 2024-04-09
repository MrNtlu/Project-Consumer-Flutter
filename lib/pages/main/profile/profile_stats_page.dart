import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/auth/user_stats.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/actor/actor_content_page.dart';
import 'package:watchlistfy/pages/main/discover/anime_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/game_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/profile_stats_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/see_all_title.dart';
import 'package:watchlistfy/widgets/main/profile/profile_chart.dart';
import 'package:watchlistfy/widgets/main/profile/profile_stats_sort_sheet.dart';
import 'package:watchlistfy/widgets/main/settings/offers_sheet.dart';

class ProfileStatsPage extends StatefulWidget {
  const ProfileStatsPage({super.key});

  @override
  State<ProfileStatsPage> createState() => _ProfileStatsPageState();
}

class _ProfileStatsPageState extends State<ProfileStatsPage> {
  DetailState _state = DetailState.init;
  String? _error;

  late final ProfileStatsProvider _provider;
  late final AuthenticationProvider _authProvider;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getProfileStatistics().then((response) {
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
      _authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      if (!_authProvider.isAuthenticated) {
        Navigator.pop(context);
      }

      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = ProfileStatsProvider();
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
      child: Consumer<ProfileStatsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text(
                "📊 Detailed Statistics"
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const FaIcon(FontAwesomeIcons.filter),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return ProfileStatsSortSheet(_fetchData, provider);
                    }
                  );
                }
              ),
            ),
            child: _body(provider)
          );
        }
      ),
    );
  }

  Widget _body(ProfileStatsProvider provider) {
    switch (_state) {
      case DetailState.view:
        final data = provider.item!;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Interval Stats
              SeeAllTitle("📊 ${provider.interval.name} Stats", () {}, shouldHideSeeAllButton: true),
              if (data.stats.isNotEmpty)
              _statsBody(data.stats),
              if (data.stats.isEmpty)
              _noDataText(),
              const SizedBox(height: 16),

              // Genres
              SeeAllTitle("🎭 Genres", () {}, shouldHideSeeAllButton: true),
              for (MostLikedGenres genre in data.genres)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Row(
                  children: [
                    CupertinoChip(
                      isSelected: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      label: genre.genre,
                      onSelected: (_) {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            switch (ContentType.values.where((element) => element.request == genre.type).first) {
                              case ContentType.movie:
                                return MovieDiscoverListPage(genre: genre.genre);
                              case ContentType.tv:
                                return TVDiscoverListPage(genre: genre.genre);
                              case ContentType.anime:
                                return AnimeDiscoverListPage(genre: genre.genre);
                              case ContentType.game:
                                return GameDiscoverListPage(genre: genre.genre);
                              default:
                              return MovieDiscoverListPage(genre: genre.genre);
                            }
                          })
                        );
                      }
                    ),
                    const Flexible(
                      fit: FlexFit.loose,
                      child: AutoSizeText(
                        " is your most liked genre in ",
                        minFontSize: 12,
                        maxLines: 1,
                        style: TextStyle(fontSize: 15)
                      ),
                    ),
                    Text(
                      "${ContentType.values.where((element) => element.request == genre.type).first.value}.",
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, color: AppColors().primaryColor, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),
              if (data.genres.isNotEmpty)
              const SizedBox(height: 16),
              if (data.genres.isEmpty)
              _noDataText(),

              // Country
              SeeAllTitle("🌍 Country", () {}, shouldHideSeeAllButton: true),
              for (MostLikedCountry country in data.countries)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Row(
                  children: [
                    CupertinoChip(
                      isSelected: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      leading: country.type != "anime"
                      ? Padding(
                        padding: const EdgeInsets.only(right: 3),
                        child: CountryFlag.fromCountryCode(
                          country.country,
                          width: 20,
                          height: 15,
                          borderRadius: 3,
                        ),
                      )
                      : null,
                      label: country.country,
                      onSelected: (_) {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            switch (ContentType.values.where((element) => element.request == country.type).first) {
                              case ContentType.movie:
                                return MovieDiscoverListPage(country: country.country);
                              case ContentType.tv:
                                return TVDiscoverListPage(country: country.country);
                              case ContentType.anime:
                                return AnimeDiscoverListPage(demographic: country.country);
                              default:
                              return MovieDiscoverListPage(country: country.country);
                            }
                          })
                        );
                      }
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: AutoSizeText(
                        " is your favourite ${country.type == "anime" ? "demographics" : "country"} in ",
                        minFontSize: 12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15)
                      ),
                    ),
                    Text(
                      "${ContentType.values.where((element) => element.request == country.type).first.value}.",
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, color: AppColors().primaryColor, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),
              ),
              if (data.countries.isEmpty)
              _noDataText(),
              const SizedBox(height: 16),

              // Actors
              SeeAllTitle("🧛‍♂️ Actors", () {}, shouldHideSeeAllButton: true),
              for (MostWatchedActors actors in data.actors)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your favourite actors in ${ContentType.values.where((element) => element.request == actors.type).first.value}",
                      style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey2),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                actors.actors.length,
                                (index) {
                                  final actor = actors.actors[index];

                                  return CupertinoChip(
                                    isSelected: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                      child: CachedNetworkImage(
                                        imageUrl: actor.image,
                                        key: ValueKey<String>(actor.image),
                                        cacheKey: actor.image,
                                        fit: BoxFit.cover,
                                        height: 24,
                                        width: 24,
                                        maxHeightDiskCache: 100,
                                        maxWidthDiskCache: 100,
                                      )
                                    ),
                                    label: actor.name,
                                    onSelected: (_) {
                                      Navigator.of(context, rootNavigator: true).push(
                                        CupertinoPageRoute(builder: (_) {
                                          return ActorContentPage(
                                            actor.id,
                                            actor.name,
                                            actor.image,
                                            isMovie: actors.type == "movie",
                                          );
                                        })
                                      );
                                    }
                                  );
                                }
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_authProvider.basicUserInfo?.isPremium == false && data.actors.isEmpty)
              _premiumError(),
              if (_authProvider.basicUserInfo?.isPremium == true && data.actors.isEmpty)
              _noDataText(),
              const SizedBox(height: 16),

              // Studios
              SeeAllTitle("🎙️ Studios", () {}, shouldHideSeeAllButton: true),
              for (MostLikedStudios studio in data.studios)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your favourite studios in ${ContentType.values.where((element) => element.request == studio.type).first.value}",
                      style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey2),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                studio.studios.length,
                                (index) {
                                  final studioName = studio.studios[index];

                                  return CupertinoChip(
                                    isSelected: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    label: studioName,
                                    onSelected: (_) {
                                      Navigator.of(context, rootNavigator: true).push(
                                        CupertinoPageRoute(builder: (_) {
                                          if (studio.type == "game") {
                                            return GameDiscoverListPage(publisher: studioName);
                                          } else {
                                            return AnimeDiscoverListPage(studios: studioName);
                                          }
                                        })
                                      );
                                    }
                                  );
                                }
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_authProvider.basicUserInfo?.isPremium == false && data.actors.isEmpty)
              _premiumError(),
              if (_authProvider.basicUserInfo?.isPremium == true && data.actors.isEmpty)
              _noDataText(),
              const SizedBox(height: 16),

              // Stats Chart
              Row(
                children: [
                  SeeAllTitle("📈 Your ${provider.interval.name} Activity", () {}, shouldHideSeeAllButton: true),
                  if (MediaQuery.of(context).orientation == Orientation.portrait)
                  const Text("(Landscape recommended)", style: TextStyle(
                    color: CupertinoColors.systemGrey2,
                    fontSize: 13,
                  ))
                ],
              ),
              if (data.logs.isNotEmpty)
              SizedBox(
                height: 250,
                child: ProfileChart(data.logs)
              ),
              if (data.logs.isEmpty)
              _noDataText(),
              const SizedBox(height: 16),
            ],
          ),
        );
      case DetailState.error:
        final isPremiumRequired = _error == "This feature requires premium membership.";
        return Center(child: ErrorView(_error ?? "Unknown error", _fetchData, isPremiumError: isPremiumRequired));
      case DetailState.loading:
        return const Center(child: LoadingView("Loading"));
      default:
        return const Center(child: LoadingView("Loading"));
    }
  }

  Widget _premiumError() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/lottie/premium.json",
              height: 32,
              width: 32,
              frameRate: FrameRate(60)
            ),
            const Text("You need premium membership to access this.", style: TextStyle(fontWeight: FontWeight.w500))
          ],
        ),
        const SizedBox(height: 8),
        CupertinoButton(
          child: const Text("Purchase", style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const OffersSheet();
              })
            );
          }
        )
      ],
    ),
  );

  Widget _noDataText() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Text("No data yet!"),
  );

  Widget _statsBody(List<FinishedLogStats> stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: stats.length * 40,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          itemExtent: 40,
          children: List.generate(
            stats.length, (index) {
              final stat = stats[index];
              final contentType = ContentType.values.where((element) => element.request == stat.contentType).first;

              final String actionText;
              const String gameExtraText = "with avg Metacritic of";
              final String statText;
              switch (contentType) {
                case ContentType.game:
                  statText = (stat.metacriticScore > 0 && stat.count > 0 ? stat.metacriticScore / stat.count : 0).round().toString();
                  actionText = "played";

                  break;
                case ContentType.movie:
                  statText = "${(stat.length / 60).round()} hrs of";
                  actionText = "watched";

                  break;
                case ContentType.tv:
                  statText = "${stat.totalSeasons} seasons and ${stat.totalEpisodes} eps of";
                  actionText = "watched";

                  break;
                case ContentType.anime:
                  statText = "${stat.totalEpisodes} eps of";
                  actionText = "watched";

                  break;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: contentType != ContentType.game
                ? Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: AutoSizeText(
                        "You $actionText $statText ",
                        minFontSize: 14,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 15)
                      ),
                    ),
                    Text(
                      "${contentType.value}.",
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, color: AppColors().primaryColor, fontWeight: FontWeight.w500)
                    ),
                  ],
                )
              : Row(
                  children: [
                    AutoSizeText(
                      "You $actionText ",
                      minFontSize: 13,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 15)
                    ),
                    AutoSizeText(
                      "${contentType.value} ",
                      minFontSize: 13,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, color: AppColors().primaryColor, fontWeight: FontWeight.w500)
                    ),
                    AutoSizeText(
                      "$gameExtraText $statText.",
                      minFontSize: 13,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 15)
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}