import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/pages/main/profile/user_list_page.dart';
import 'package:watchlistfy/pages/main/profile/consume_later_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_stats_page.dart';

class ProfileStats extends StatefulWidget {
  final UserInfo item;
  final VoidCallback? onRefresh;

  const ProfileStats(this.item, {this.onRefresh, super.key});

  @override
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  bool isInit = false;
  bool isExpanded = false;
  late final GlobalProvider globalProvider;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      globalProvider = Provider.of<GlobalProvider>(context);
      isExpanded =
          globalProvider.statsMode == Constants.ProfileStatisticsUIModes.first;
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Navigation Buttons
          _buildTopNavigationButtons(theme),
          const SizedBox(height: 16),

          // Header with Statistics title and expand/collapse button
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors().primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      CupertinoIcons.chart_bar_fill,
                      color: AppColors().primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Statistics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors().primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors().primaryColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isExpanded
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                      color: AppColors().primaryColor,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 16),
            _buildStatsGrid(),
          ],
        ],
      ),
    );
  }

  Widget _buildTopNavigationButtons(CupertinoThemeData theme) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavigationButton(
            icon: FontAwesomeIcons.listUl,
            label: "User List",
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) => const UserListPage()),
              );
            },
          ),
          _buildNavigationButton(
            icon: FontAwesomeIcons.solidClock,
            label: "Watch Later",
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(
                    CupertinoPageRoute(
                        builder: (_) => const ConsumeLaterPage()),
                  )
                  .then((_) => widget.onRefresh?.call());
            },
          ),
          _buildNavigationButton(
            icon: FontAwesomeIcons.squarePollVertical,
            label: "Detailed Stats",
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) => const ProfileStatsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors().primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaIcon(
                icon,
                color: AppColors().primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.systemGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: FontAwesomeIcons.film,
                  iconColor: CupertinoColors.systemRed,
                  count: widget.item.movieCount,
                  label: "Movies",
                  extraInfo:
                      "${(widget.item.movieWatchedTime / 60).round()} hrs",
                  extraLabel: "Watched",
                  rating: widget.item.movieAvgScore,
                  progress: _calculateProgress(widget.item.movieCount,
                      100), // Assuming 100 as max for demo
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: FontAwesomeIcons.tv,
                  iconColor: CupertinoColors.systemBlue,
                  count: widget.item.tvCount,
                  label: "TV Series",
                  extraInfo: "${widget.item.tvWatchedEpisodes} eps",
                  extraLabel: "Watched",
                  rating: widget.item.tvAvgScore,
                  progress: _calculateProgress(widget.item.tvCount, 200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: FontAwesomeIcons.play,
                  iconColor: CupertinoColors.systemPurple,
                  count: widget.item.animeCount,
                  label: "Anime",
                  extraInfo: "${widget.item.animeWatchedEpisodes} eps",
                  extraLabel: "Watched",
                  rating: widget.item.animeAvgScore,
                  progress: _calculateProgress(widget.item.animeCount, 150),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: FontAwesomeIcons.gamepad,
                  iconColor: CupertinoColors.systemGreen,
                  count: widget.item.gameCount,
                  label: "Games",
                  extraInfo: "${widget.item.gameTotalHoursPlayed} hrs",
                  extraLabel: "Played",
                  rating: widget.item.gameAvgScore,
                  progress: _calculateProgress(widget.item.gameCount, 50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required int count,
    required String label,
    required String extraInfo,
    required String extraLabel,
    required double rating,
    required double progress,
  }) {
    final theme = CupertinoTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey4.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and count
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  icon,
                  color: iconColor,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Label
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Extra info
          Text(
            extraInfo,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.systemGrey2,
            ),
          ),
          Text(
            extraLabel,
            style: const TextStyle(
              fontSize: 11,
              color: CupertinoColors.systemGrey2,
            ),
          ),
          const SizedBox(height: 8),

          // Rating with "Avg Score" label
          Row(
            children: [
              const Icon(
                CupertinoIcons.star_fill,
                color: CupertinoColors.systemYellow,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors().primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "Avg Score",
                style: TextStyle(
                  fontSize: 11,
                  color: CupertinoColors.systemGrey2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateProgress(int current, int max) {
    if (max == 0) return 0.0;
    return (current / max).clamp(0.0, 1.0);
  }
}
