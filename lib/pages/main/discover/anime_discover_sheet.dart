import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/discover/discover_anime_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class AnimeDiscoverSheet extends StatelessWidget {
  final Function(bool) fetchData;
  final DiscoverAnimeProvider provider;

  const AnimeDiscoverSheet(this.fetchData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortRequests.where((element) => element.request == provider.sort).first.name,
      Constants.SortRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final genres = Constants.AnimeGenreList.map((e) => e.name).toList();
    genres.removeAt(0);
    final genreList = DiscoverSheetList(
      Constants.AnimeGenreList.where((element) => element.name == provider.genre).firstOrNull?.name,
      genres,
    );

    final demographicList = DiscoverSheetList(
      Constants.AnimeDemographicsList.where((element) => element.name == provider.demographics).firstOrNull?.name,
      Constants.AnimeDemographicsList.map((e) => e.name).toList()
    );

    final themeList = DiscoverSheetList(
      Constants.AnimeThemeList.where((element) => element.name == provider.themes).firstOrNull?.name,
      Constants.AnimeThemeList.map((e) => e.name).toList()
    );

    final statusList = DiscoverSheetList(
      Constants.AnimeStatusRequests.where((element) => element.request == provider.status).firstOrNull?.name,
      Constants.AnimeStatusRequests.map((e) => e.name).toList()
    );

    final seasonList = DiscoverSheetList(
      Constants.AnimeSeasonList.where((element) => element.request == provider.season).firstOrNull?.name,
      Constants.AnimeSeasonList.map((e) => e.name).toList()
    );

    int currentYear = DateTime.now().year+1;
    int startingYear = 1980;

    List yearList = List.generate((currentYear-startingYear)+1, (index) => startingYear+index).reversed.toList();

    final yearDiscoverList = DiscoverSheetList(
      yearList.where((element) => element == provider.year).firstOrNull?.toString(),
      yearList.map((e) => e.toString()).toList()
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
                  DiscoverSheetFilterBody("Demographics", demographicList),
                  DiscoverSheetFilterBody("Themes", themeList),
                  DiscoverSheetFilterBody("Status", statusList),
                  DiscoverSheetFilterBody("Season", seasonList),
                  DiscoverSheetFilterBody("Year", yearDiscoverList),
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
                      genre: Constants.AnimeGenreList.where((element) => element.name == genreList.selectedValue).firstOrNull?.name,
                      demographics: Constants.AnimeDemographicsList.where((element) => element.name == demographicList.selectedValue).firstOrNull?.name,
                      themes: Constants.AnimeThemeList.where((element) => element.name == themeList.selectedValue).firstOrNull?.name,
                      status: Constants.AnimeStatusRequests.where((element) => element.name == statusList.selectedValue).firstOrNull?.request,
                      season: Constants.AnimeSeasonList.where((element) => element.name == seasonList.selectedValue).firstOrNull?.request,
                      year: yearList.where((element) => element.toString() == yearDiscoverList.selectedValue?.toString()).firstOrNull,
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