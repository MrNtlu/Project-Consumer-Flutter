import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/profile/profile_stats_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_premium_list.dart';

class ProfileStatsSortSheet extends StatelessWidget {
  final VoidCallback _fetchData;
  final ProfileStatsProvider _provider;

  const ProfileStatsSortSheet(this._fetchData, this._provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final intervalList = DiscoverSheetPremiumList(
      Constants.ProfileStatsInterval.where(
        (element) => element.request == _provider.interval.request
      ).first.name,
      Constants.ProfileStatsInterval.map((e) {
        return PremiumSheet(e.name, e.request != "weekly");
      }).toList(),
    );

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DiscoverSheetFilterPremiumBody("Interval", intervalList),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
                final newInterval = Constants.ProfileStatsInterval.where((element) => element.name == intervalList.selectedValue!).first;
                final shouldFetchData = _provider.interval.request != newInterval.request;

                _provider.interval = newInterval;

                if (shouldFetchData) {
                  _fetchData();
                }
              },
              child: const Text(
                "Done",
                style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold, fontSize: 16)
              ),
            )
          ],
        ),
      )
    );
  }
}