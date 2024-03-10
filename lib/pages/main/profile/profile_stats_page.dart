import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/auth/user_stats.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
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

class ProfileStatsPage extends StatefulWidget {
  const ProfileStatsPage({super.key});

  @override
  State<ProfileStatsPage> createState() => _ProfileStatsPageState();
}

class _ProfileStatsPageState extends State<ProfileStatsPage> {
  DetailState _state = DetailState.init;
  String? _error;

  late final ProfileStatsProvider _provider;

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
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
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
              SeeAllTitle("🎭 Genres", () {}, shouldHideSeeAllButton: true),
              for (MostLikedGenres genre in data.genres)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Row(
                  children: [
                    CupertinoChip(
                      isSelected: false,
                      label: genre.genre,
                      onSelected: (_) {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            switch (ContentType.values.where((element) => element.request == genre.type).first) {
                              case ContentType.movie:
                                return MovieDiscoverListPage(genre: Uri.encodeQueryComponent(genre.genre));
                              case ContentType.tv:
                                return TVDiscoverListPage(genre: Uri.encodeQueryComponent(genre.genre));
                              case ContentType.anime:
                                return AnimeDiscoverListPage(genre: Uri.encodeQueryComponent(genre.genre));
                              case ContentType.game:
                                return GameDiscoverListPage(genre: Uri.encodeQueryComponent(genre.genre));
                              default:
                              return MovieDiscoverListPage(genre: Uri.encodeQueryComponent(genre.genre));
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
              const Text("No data yet!"),
              SeeAllTitle("📊 ${provider.interval.name} Stats", () {}, shouldHideSeeAllButton: true),
              if (data.stats.isNotEmpty)
              _statsBody(data.stats),
              if (data.stats.isEmpty)
              const Text("No data yet!"),
              if (data.stats.isNotEmpty)
              const SizedBox(height: 16),
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
              const Text("No data yet!"),
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