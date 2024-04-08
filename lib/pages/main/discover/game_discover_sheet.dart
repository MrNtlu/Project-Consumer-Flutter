import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/discover/discover_game_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class GameDiscoverSheet extends StatelessWidget {
  final Function(bool) fetchData;
  final DiscoverGameProvider provider;

  const GameDiscoverSheet(this.fetchData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortRequests.where((element) => element.request == provider.sort).first.name,
      Constants.SortRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final genres = Constants.GameGenreList.map((e) => e.name).toList();
    genres.removeAt(0);
    final genreList = DiscoverSheetList(
      Constants.GameGenreList.where((element) => element.name == provider.genre).firstOrNull?.name,
      genres,
    );

    final platformList = DiscoverSheetList(
      Constants.GamePlatformRequests.where((element) => element.request == provider.platform).firstOrNull?.name,
      Constants.GamePlatformRequests.map((e) => e.name).toList(),
      iconList: Constants.GamePlatformIcons,
    );

    return SafeArea(
      child: Container(
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  DiscoverSheetFilterBody("Sort", sortList),
                  DiscoverSheetFilterBody("Genre", genreList),
                  DiscoverSheetFilterBody("Platforms", platformList),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  child: const Text("Reset", style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 14)),
                  onPressed: () {
                    Navigator.pop(context);
                    provider.reset();
                    fetchData(true);
                  }
                ),
                CupertinoButton.filled(
                  onPressed: () {
                    Navigator.pop(context);
                    provider.setDiscover(
                      sort: Constants.SortRequests.where((element) => element.name == sortList.selectedValue!).first.request,
                      genre: Constants.GameGenreList.where((element) => element.name == genreList.selectedValue).firstOrNull?.name,
                      platform: Constants.GamePlatformRequests.where((element) => element.name == platformList.selectedValue).firstOrNull?.request,
                    );
                    fetchData(true);
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                )
              ],
            ),
            const SizedBox(height: 3)
          ],
        ),
      ),
    );
  }
}