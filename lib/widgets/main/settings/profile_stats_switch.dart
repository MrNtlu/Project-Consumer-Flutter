import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/constants.dart';

class ProfileStatsSwitch extends StatelessWidget {
  const ProfileStatsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final isExpanded = globalProvider.statsMode == Constants.ProfileStatisticsUIModes.first;

    return SettingsTile.switchTile(
      onToggle: (_) {
        globalProvider.setStatsMode(
          isExpanded
          ? Constants.ProfileStatisticsUIModes.last
          : Constants.ProfileStatisticsUIModes.first
        );
      },
      initialValue: isExpanded,
      leading: Icon(isExpanded ? FontAwesomeIcons.expand : FontAwesomeIcons.compress),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Profile Stats ${isExpanded ? 'Expanded' : 'Collapsed'}',
            minFontSize: 13,
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 3),
          AutoSizeText(
            "Profile statistics will be ${isExpanded ? 'expanded' : 'collapsed'}.",
            minFontSize: 10,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              color: CupertinoColors.systemGrey
            ),
          ),
        ],
      ),
    );
  }
}