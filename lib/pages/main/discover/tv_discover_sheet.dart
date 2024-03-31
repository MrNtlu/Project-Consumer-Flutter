import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/discover/discover_tv_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_image_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class TVDiscoverSheet extends StatelessWidget {
  final Function(bool) fetchData;
  final DiscoverTVProvider provider;

  const TVDiscoverSheet(this.fetchData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortRequests.where((element) => element.request == provider.sort).first.name,
      Constants.SortRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final genres = Constants.TVGenreList.map((e) => e.name).toList();
    genres.removeAt(0);
    final genreList = DiscoverSheetList(
      Constants.TVGenreList.where((element) => element.name == provider.genre).firstOrNull?.name,
      genres,
    );

    final statusList = DiscoverSheetList(
      Constants.TVSeriesStatusRequests.where((element) => element.request == provider.status).firstOrNull?.name,
      Constants.TVSeriesStatusRequests.map((e) => e.name).toList()
    );

    final numOfSeasonList = DiscoverSheetList(
      Constants.NumOfSeasonList.where((element) => element == provider.numOfSeason).firstOrNull,
      Constants.NumOfSeasonList.map((e) => e).toList()
    );

    final decadeList = DiscoverSheetList(
      Constants.DecadeList.where((element) => element.request == provider.decade).firstOrNull?.name,
      Constants.DecadeList.map((e) => e.name).toList()
    );

    final countryList = DiscoverSheetList(
      Constants.TVPopularCountries.where((element) => element.request == provider.country).firstOrNull?.name,
      Constants.TVPopularCountries.map((e) => e.name).toList()
    );

    final streamingPlatformList = DiscoverSheetImageList(
      Constants.TVStreamingPlatformList.where(
        (element) => element.request == provider.streaming
      ).firstOrNull?.name,
      Constants.TVStreamingPlatformList.map((e) => e.name).toList(),
      Constants.TVStreamingPlatformList.map((e) => e.image).toList(),
    );

    return SafeArea(
      child: ColoredBox(
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DiscoverSheetFilterBody("Sort", sortList),
                    DiscoverSheetImageFilterBody("Streaming Platforms", streamingPlatformList),
                    DiscoverSheetFilterBody("Genre", genreList),
                    DiscoverSheetFilterBody("Status", statusList),
                    DiscoverSheetFilterBody("Number of Seasons", numOfSeasonList),
                    DiscoverSheetFilterBody("Release Date", decadeList),
                    DiscoverSheetFilterBody("Country", countryList),
                  ],
                ),
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

                    final newSort = Constants.SortRequests.where((element) => element.name == sortList.selectedValue!).first.request;
                    final newGenre = Constants.TVGenreList.where((element) => element.name == genreList.selectedValue).firstOrNull?.name;
                    final newStatus = Constants.TVSeriesStatusRequests.where((element) => element.name == statusList.selectedValue).firstOrNull?.request;
                    final newNumOfSeason = Constants.NumOfSeasonList.where((element) => element == numOfSeasonList.selectedValue).firstOrNull;
                    final newDecade = Constants.DecadeList.where((element) => element.name == decadeList.selectedValue).firstOrNull?.request;
                    final newCountry = Constants.TVPopularCountries.where((element) => element.name == countryList.selectedValue).firstOrNull?.request;
                    final newStreaming = Constants.TVStreamingPlatformList.where((element) => element.name == streamingPlatformList.selectedValue).firstOrNull?.request;

                    final shouldFetchData = provider.sort != newSort
                      || provider.genre != newGenre
                      || provider.status != newStatus
                      || provider.numOfSeason != newNumOfSeason
                      || provider.streaming != newStreaming
                      || provider.decade != newDecade
                      || provider.country != newCountry
                      || provider.streaming != newStreaming;

                    provider.setDiscover(
                      sort: newSort,
                      genre: newGenre,
                      status: newStatus,
                      numOfSeason: newNumOfSeason,
                      decade: newDecade,
                      country: newCountry,
                      streaming: newStreaming,
                    );

                    if (shouldFetchData) {
                      fetchData(true);
                    }
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3)
          ],
        ),
      ),
    );
  }
}