import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/main/discover/discover_anime_provider.dart';
import 'package:watchlistfy/providers/main/discover/discover_streaming_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_image_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_slider.dart';

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

    final ratingSlider = DiscoverSheetSlider(value: provider.rating);

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

    final streamingPlatformList = DiscoverSheetImageList(
      Constants.AnimeStreamingPlatformList.where(
        (element) => element.request == provider.streaming
      ).firstOrNull?.name,
      Constants.AnimeStreamingPlatformList.map((e) => e.name).toList(),
      Constants.AnimeStreamingPlatformList.map((e) => e.image).toList(),
    );

    final studiosList = DiscoverSheetImageList(
      Constants.AnimePopularStudiosList.where(
        (element) => element.request == provider.studios
      ).firstOrNull?.name,
      Constants.AnimePopularStudiosList.map((e) => e.name).toList(),
      Constants.AnimePopularStudiosList.map((e) => e.image).toList(),
    );

    return SafeArea(
      child: ColoredBox(
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        DiscoverSheetFilterBody("Sort", sortList),
                        ratingSlider,
                        ChangeNotifierProvider(
                          create: (_) => StreamingPlatformStateProvider(),
                          child: DiscoverSheetImageFilterBody("Streaming Platforms", streamingPlatformList)
                        ),
                        ChangeNotifierProvider(
                          create: (_) => StreamingPlatformStateProvider(),
                          child: DiscoverSheetImageFilterBody("Studios", studiosList)
                        ),
                        DiscoverSheetFilterBody("Genre", genreList),
                        DiscoverSheetFilterBody("Demographics", demographicList),
                        DiscoverSheetFilterBody("Themes", themeList),
                        DiscoverSheetFilterBody("Status", statusList),
                        DiscoverSheetFilterBody("Season", seasonList),
                        DiscoverSheetFilterBody("Year", yearDiscoverList),
                        const SizedBox(height: 76),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width - (12 + MediaQuery.paddingOf(context).horizontal),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          color: CupertinoTheme.of(context).onBgColor.withOpacity(0.75)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CupertinoButton(
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  color: CupertinoColors.destructiveRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
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
                                final newGenre = Constants.AnimeGenreList.where((element) => element.name == genreList.selectedValue).firstOrNull?.name;
                                final newDemographics = Constants.AnimeDemographicsList.where((element) => element.name == demographicList.selectedValue).firstOrNull?.name;
                                final newThemes = Constants.AnimeThemeList.where((element) => element.name == themeList.selectedValue).firstOrNull?.name;
                                final newStatus = Constants.AnimeStatusRequests.where((element) => element.name == statusList.selectedValue).firstOrNull?.request;
                                final newSeason = Constants.AnimeSeasonList.where((element) => element.name == seasonList.selectedValue).firstOrNull?.request;
                                final newYear = yearList.where((element) => element.toString() == yearDiscoverList.selectedValue?.toString()).firstOrNull;
                                final newStreaming = Constants.AnimeStreamingPlatformList.where((element) => element.name == streamingPlatformList.selectedValue).firstOrNull?.request;
                                final newStudio = Constants.AnimePopularStudiosList.where((element) => element.name == studiosList.selectedValue).firstOrNull?.request;

                                final shouldFetchData = provider.sort != newSort
                                  || provider.genre != newGenre
                                  || provider.demographics != newDemographics
                                  || provider.themes != newThemes
                                  || provider.status != newStatus
                                  || provider.season != newSeason
                                  || provider.year != newYear
                                  || provider.streaming != newStreaming
                                  || provider.studios != newStudio
                                  || ratingSlider.value != provider.rating;

                                provider.setDiscover(
                                  sort: newSort,
                                  genre: newGenre,
                                  demographics: newDemographics,
                                  themes: newThemes,
                                  status: newStatus,
                                  season: newSeason,
                                  year: newYear,
                                  streaming: newStreaming,
                                  studios: newStudio,
                                  rating: ratingSlider.value,
                                );

                                if (shouldFetchData) {
                                  fetchData(true);
                                }
                              },
                              child: const Text(
                                "Done",
                                style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 16)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6)
          ],
        ),
      ),
    );
  }
}