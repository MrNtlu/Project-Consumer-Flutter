import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
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
import 'package:watchlistfy/static/refresh_rate_helper.dart';
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
              : (response.data != null ? DetailState.view : DetailState.error);
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
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
              middle: const Text("📊 Detailed Statistics"),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const FaIcon(FontAwesomeIcons.filter),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return ProfileStatsSortSheet(
                        _fetchData,
                        provider,
                      );
                    },
                  );
                },
              ),
            ),
            child: _body(provider, context),
          );
        },
      ),
    );
  }

  Widget _body(ProfileStatsProvider provider, BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final primaryColor = AppColors().primaryColor;

    switch (_state) {
      case DetailState.view:
        final data = provider.item!;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Interval Stats
              SeeAllTitle("📊 ${provider.interval.name} Stats"),
              if (data.stats.isNotEmpty)
                _statsBody(data.stats, theme, primaryColor),
              if (data.stats.isEmpty) _noDataText(),
              const SizedBox(height: 16),

              // Genres
              const SeeAllTitle("🎭 Genres"),
              for (MostLikedGenres genre in data.genres)
                _buildGenreItem(genre, theme, primaryColor),
              if (data.genres.isNotEmpty) const SizedBox(height: 16),
              if (data.genres.isEmpty) _noDataText(),

              // Country
              const SeeAllTitle("🌍 Country"),
              for (MostLikedCountry country in data.countries)
                _buildCountryItem(country, theme, primaryColor),
              if (data.countries.isEmpty) _noDataText(),
              const SizedBox(height: 16),

              // Actors
              const SeeAllTitle("🧛‍♂️ Actors"),
              for (MostWatchedActors actors in data.actors)
                _buildActorsSection(actors, theme, primaryColor),
              if (_authProvider.basicUserInfo?.isPremium == false &&
                  data.actors.isEmpty)
                _premiumError(theme, primaryColor),
              if (_authProvider.basicUserInfo?.isPremium == true &&
                  data.actors.isEmpty)
                _noDataText(),
              const SizedBox(height: 16),

              // Studios
              const SeeAllTitle("🎙️ Studios"),
              for (MostLikedStudios studio in data.studios)
                _buildStudiosSection(studio, theme, primaryColor),
              if (_authProvider.basicUserInfo?.isPremium == false &&
                  data.actors.isEmpty)
                _premiumError(theme, primaryColor),
              if (_authProvider.basicUserInfo?.isPremium == true &&
                  data.actors.isEmpty)
                _noDataText(),
              const SizedBox(height: 16),

              // Content Distribution
              if (data.contentTypeDistribution.isNotEmpty) ...[
                const SeeAllTitle("📊 Content Distribution"),
                _buildStandardContainer(
                  theme,
                  child: SizedBox(
                    height: 250,
                    child: ProfileChart([],
                        contentTypeDistribution: data.contentTypeDistribution),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Completion Rate
              if (data.completionRate.totalContent > 0) ...[
                const SeeAllTitle("✅ Completion Stats"),
                _buildCompletionRateSection(
                    data.completionRate, theme, primaryColor),
                const SizedBox(height: 16),
              ],

              // Average Ratings
              if (data.averageRatingByType.isNotEmpty) ...[
                const SeeAllTitle("⭐ Average Ratings"),
                _buildAverageRatingsSection(
                    data.averageRatingByType, theme, primaryColor),
                const SizedBox(height: 16),
              ],

              // Stats Chart
              Row(
                children: [
                  SeeAllTitle("📈 Your ${provider.interval.name} Activity"),
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait)
                    const Text(
                      "(Landscape recommended)",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey2,
                        fontSize: 13,
                      ),
                    )
                ],
              ),
              if (data.logs.isNotEmpty)
                _buildActivityChartContainer(data, provider, theme),
              if (data.logs.isEmpty) _noDataText(),
              const SizedBox(height: 16),
            ],
          ),
        );
      case DetailState.error:
        final isPremiumRequired =
            _error == "This feature requires premium membership.";
        return Center(
            child: ErrorView(_error ?? "Unknown error", _fetchData,
                isPremiumError: isPremiumRequired));
      case DetailState.loading:
        return const Center(child: LoadingView("Loading"));
      default:
        return const Center(child: LoadingView("Loading"));
    }
  }

  Widget _buildStandardContainer(CupertinoThemeData theme,
      {required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.barBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActivityChartContainer(
      UserStats data, ProfileStatsProvider provider, CupertinoThemeData theme) {
    final isScrollable =
        data.logs.length > 7; // More data points for 3-month intervals
    final isThreeMonthInterval =
        provider.interval.name.toLowerCase().contains('3') ||
            provider.interval.name.toLowerCase().contains('month');

    return Column(
      children: [
        if (isScrollable || isThreeMonthInterval)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.barBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.systemBlue.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    CupertinoIcons.hand_draw,
                    size: 16,
                    color: CupertinoColors.systemBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Scrollable Chart",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                      Text(
                        isThreeMonthInterval
                            ? "Swipe horizontally to explore your activity timeline"
                            : "Swipe left and right to see more data points",
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  CupertinoIcons.arrow_left_right,
                  size: 18,
                  color: CupertinoColors.systemBlue,
                ),
              ],
            ),
          ),
        if (isScrollable || isThreeMonthInterval) const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ProfileChart(
            data.logs,
            contentTypeDistribution: data.contentTypeDistribution,
          ),
        ),
      ],
    );
  }

  Widget _premiumError(CupertinoThemeData theme, Color primaryColor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: _buildStandardContainer(
          theme,
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
                    frameRate: FrameRate(
                      RefreshRateHelper().getRefreshRate(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "You need premium membership to access this.",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: const Text(
                  "Purchase Premium",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (_) => const OffersSheet(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );

  Widget _noDataText() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text("No data yet!"),
      );

  Widget _buildCompletionRateSection(CompletionRate completionRate,
      CupertinoThemeData theme, Color primaryColor) {
    return _buildStandardContainer(
      theme,
      child: Column(
        children: [
          // Progress bars
          _buildProgressBar(
            "Completed",
            completionRate.finishedContent,
            completionRate.totalContent,
            completionRate.completionRate,
            CupertinoColors.systemGreen,
            theme,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            "Active",
            completionRate.activeContent,
            completionRate.totalContent,
            (completionRate.activeContent / completionRate.totalContent) * 100,
            CupertinoColors.systemBlue,
            theme,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            "Dropped",
            completionRate.droppedContent,
            completionRate.totalContent,
            completionRate.dropRate,
            CupertinoColors.systemRed,
            theme,
          ),
          const SizedBox(height: 16),
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.systemGrey4.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Total", completionRate.totalContent.toString(),
                    primaryColor),
                _buildStatItem(
                    "Completion",
                    "${completionRate.completionRate.toStringAsFixed(1)}%",
                    primaryColor),
                _buildStatItem(
                    "Drop Rate",
                    "${completionRate.dropRate.toStringAsFixed(1)}%",
                    primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, int value, int total,
      double percentage, Color color, CupertinoThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              "$value / $total (${percentage.toStringAsFixed(1)}%)",
              style: const TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: CupertinoColors.systemGrey4.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color primaryColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageRatingsSection(List<AverageRatingByType> ratings,
      CupertinoThemeData theme, Color primaryColor) {
    return _buildStandardContainer(
      theme,
      child: Column(
        children: ratings.asMap().entries.map((entry) {
          final index = entry.key;
          final rating = entry.value;
          final contentType = ContentType.values
              .where((e) => e.request == rating.contentType)
              .firstOrNull;

          return Column(
            children: [
              if (index > 0) const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CupertinoColors.systemGrey4.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Content type icon and name
                    Expanded(
                      flex: 2,
                      child: Text(
                        contentType?.value ?? rating.contentType,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // Rating
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.star_fill,
                            color: CupertinoColors.systemYellow,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.averageRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Count
                    Expanded(
                      child: Text(
                        "${rating.totalRated} rated",
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _statsBody(List<FinishedLogStats> stats, CupertinoThemeData theme,
      Color primaryColor) {
    return _buildStandardContainer(
      theme,
      child: Column(
        children: List.generate(
          stats.length,
          (index) {
            final stat = stats[index];
            final contentType = ContentType.values
                .where((element) => element.request == stat.contentType)
                .first;

            final String actionText;
            const String gameExtraText = "with avg Metacritic of";
            final String statText;
            switch (contentType) {
              case ContentType.game:
                statText = (stat.metacriticScore > 0 && stat.count > 0
                        ? stat.metacriticScore / stat.count
                        : 0)
                    .round()
                    .toString();
                actionText = "played";

                break;
              case ContentType.movie:
                statText = "${(stat.length / 60).round()} hrs of";
                actionText = "watched";

                break;
              case ContentType.tv:
                statText =
                    "${stat.totalSeasons} seasons and ${stat.totalEpisodes} eps of";
                actionText = "watched";

                break;
              case ContentType.anime:
                statText = "${stat.totalEpisodes} eps of";
                actionText = "watched";

                break;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: contentType != ContentType.game
                  ? Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: AutoSizeText("You $actionText $statText ",
                              minFontSize: 14,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 15)),
                        ),
                        Text(
                          "${contentType.value}.",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        AutoSizeText(
                          "You $actionText ",
                          minFontSize: 13,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 15),
                        ),
                        AutoSizeText(
                          "${contentType.value} ",
                          minFontSize: 13,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AutoSizeText(
                          "$gameExtraText $statText.",
                          minFontSize: 13,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenreItem(
      MostLikedGenres genre, CupertinoThemeData theme, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            CupertinoChip(
              isSelected: true,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              label: genre.genre,
              onSelected: (_) {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (_) {
                      switch (ContentType.values
                          .where((element) => element.request == genre.type)
                          .first) {
                        case ContentType.movie:
                          return MovieDiscoverListPage(genre: genre.genre);
                        case ContentType.tv:
                          return TVDiscoverListPage(genre: genre.genre);
                        case ContentType.anime:
                          return AnimeDiscoverListPage(genre: genre.genre);
                        case ContentType.game:
                          return GameDiscoverListPage(genre: genre.genre);
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AutoSizeText(
                " is your most liked genre in ",
                minFontSize: 12,
                maxLines: 1,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Text(
              "${ContentType.values.where((element) => element.request == genre.type).first.value}.",
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryItem(
      MostLikedCountry country, CupertinoThemeData theme, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
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
                  CupertinoPageRoute(
                    builder: (_) {
                      switch (ContentType.values
                          .where((element) => element.request == country.type)
                          .first) {
                        case ContentType.movie:
                          return MovieDiscoverListPage(
                              country: country.country);
                        case ContentType.tv:
                          return TVDiscoverListPage(country: country.country);
                        case ContentType.anime:
                          return AnimeDiscoverListPage(
                              demographic: country.country);
                        default:
                          return MovieDiscoverListPage(
                              country: country.country);
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AutoSizeText(
                " is your favourite ${country.type == "anime" ? "demographics" : "country"} in ",
                minFontSize: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Text(
              "${ContentType.values.where((element) => element.request == country.type).first.value}.",
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActorsSection(
      MostWatchedActors actors, CupertinoThemeData theme, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your favourite actors in ${ContentType.values.where((element) => element.request == actors.type).first.value}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: CupertinoColors.systemGrey2,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: actors.actors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final actor = actors.actors[index];
                  return CupertinoChip(
                    isSelected: true,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: actor.image,
                        key: ValueKey<String>(actor.image),
                        cacheKey: actor.image,
                        fit: BoxFit.cover,
                        height: 24,
                        width: 24,
                        cacheManager: CustomCacheManager(),
                        maxHeightDiskCache: 100,
                        maxWidthDiskCache: 100,
                      ),
                    ),
                    label: actor.name,
                    onSelected: (_) {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) => ActorContentPage(
                            actor.id,
                            actor.name,
                            actor.image,
                            isMovie: actors.type == "movie",
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudiosSection(
      MostLikedStudios studio, CupertinoThemeData theme, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your favourite studios in ${ContentType.values.where((element) => element.request == studio.type).first.value}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: CupertinoColors.systemGrey2,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: studio.studios.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final studioName = studio.studios[index];
                  return CupertinoChip(
                    isSelected: true,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    label: studioName,
                    onSelected: (_) {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) {
                            if (studio.type == "game") {
                              return GameDiscoverListPage(
                                  publisher: studioName);
                            } else {
                              return AnimeDiscoverListPage(studios: studioName);
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
