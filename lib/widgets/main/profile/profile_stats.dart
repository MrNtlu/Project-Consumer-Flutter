import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/profile/profile_extra_info_text.dart';
import 'package:watchlistfy/widgets/main/profile/profile_info_text.dart';

class ProfileStats extends StatefulWidget {
  final UserInfo item;

  const ProfileStats(this.item, {super.key});

  @override
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            color: CupertinoTheme.of(context).profileButton,
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Icon(CupertinoIcons.chart_bar_fill, color: AppColors().primaryColor, size: 20),
                    )
                  ),
                  Text(
                    "Statistics",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors().primaryColor,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: FaIcon(
                        isExpanded
                        ? FontAwesomeIcons.downLeftAndUpRightToCenter
                        : FontAwesomeIcons.upRightAndDownLeftFromCenter,
                        color: AppColors().primaryColor,
                        size: 18
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
          if(isExpanded)
          _infoText()
        ],
      ),
    );
  }

  Widget _infoText() => Column(
    children: [
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileInfoText(widget.item.movieCount.toString(), "Movies"),
            ProfileInfoText(widget.item.tvCount.toString(), "TV Series"),
            ProfileInfoText(widget.item.animeCount.toString(), "Anime"),
            ProfileInfoText(widget.item.gameCount.toString(), "Games"),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileExtraInfoText((widget.item.movieWatchedTime / 60).round().toString(), "hrs", "Watched"),
            ProfileExtraInfoText(widget.item.tvWatchedEpisodes.toString(), "eps", "Watched"),
            ProfileExtraInfoText(widget.item.animeWatchedEpisodes.toString(), "eps", "Watched"),
            ProfileExtraInfoText(widget.item.gameTotalHoursPlayed.toString(), "hrs", "Played"),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileExtraInfoText(widget.item.movieAvgScore.toString(), "⭐", "Avg Score"),
            ProfileExtraInfoText(widget.item.tvAvgScore.toString(), "⭐", "Avg Score"),
            ProfileExtraInfoText(widget.item.animeAvgScore.toString(), "⭐", "Avg Score"),
            ProfileExtraInfoText(widget.item.gameAvgScore.toString(), "⭐", "Avg Score"),
          ],
        ),
      ),
    ],
  );
}