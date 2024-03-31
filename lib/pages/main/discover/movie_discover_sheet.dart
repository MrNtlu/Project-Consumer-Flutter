import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/discover/discover_movie_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_image_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class MovieDiscoverSheet extends StatelessWidget {
  final Function(bool) fetchData;
  final DiscoverMovieProvider provider;

  const MovieDiscoverSheet(this.fetchData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortRequests.where((element) => element.request == provider.sort).first.name,
      Constants.SortRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final genres = Constants.MovieGenreList.map((e) => e.name).toList();
    genres.removeAt(0);
    final genreList = DiscoverSheetList(
      Constants.MovieGenreList.where((element) => element.name == provider.genre).firstOrNull?.name,
      genres,
    );

    final statusList = DiscoverSheetList(
      Constants.MovieStatusRequests.where((element) => element.request == provider.status).firstOrNull?.name,
      Constants.MovieStatusRequests.map((e) => e.name).toList()
    );

    final decadeList = DiscoverSheetList(
      Constants.DecadeList.where((element) => element.request == provider.decade).firstOrNull?.name,
      Constants.DecadeList.map((e) => e.name).toList()
    );

    final countryList = DiscoverSheetList(
      Constants.MoviePopularCountries.where((element) => element.request == provider.country).firstOrNull?.name,
      Constants.MoviePopularCountries.map((e) => e.name).toList()
    );

    final streamingPlatformList = DiscoverSheetImageList(
      Constants.MovieStreamingPlatformList.where(
        (element) => element.request == provider.streaming
      ).firstOrNull?.name,
      Constants.MovieStreamingPlatformList.map((e) => e.name).toList(),
      Constants.MovieStreamingPlatformList.map((e) => e.image).toList(),
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
                    final newGenre = Constants.MovieGenreList.where((element) => element.name == genreList.selectedValue).firstOrNull?.name;
                    final newStatus = Constants.MovieStatusRequests.where((element) => element.name == statusList.selectedValue).firstOrNull?.request;
                    final newDecade = Constants.DecadeList.where((element) => element.name == decadeList.selectedValue).firstOrNull?.request;
                    final newCountry = Constants.MoviePopularCountries.where((element) => element.name == countryList.selectedValue).firstOrNull?.request;
                    final newStreaming = Constants.MovieStreamingPlatformList.where((element) => element.name == streamingPlatformList.selectedValue).firstOrNull?.request;

                    final shouldFetchData = provider.sort != newSort
                      || provider.genre != newGenre
                      || provider.status != newStatus
                      || provider.streaming != newStreaming
                      || provider.decade != newDecade
                      || provider.country != newCountry;

                    provider.setDiscover(
                      sort: newSort,
                      genre: newGenre,
                      status: newStatus,
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