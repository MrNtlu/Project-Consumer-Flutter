import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/main/discover/discover_game_provider.dart';
import 'package:watchlistfy/providers/main/discover/discover_streaming_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_image_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_slider.dart';

class GameDiscoverSheet extends StatelessWidget {
  final Function(bool) fetchData;
  final DiscoverGameProvider provider;

  const GameDiscoverSheet(this.fetchData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    final sortList = DiscoverSheetList(
      Constants.SortRequests.where(
        (element) => element.request == provider.sort,
      ).first.name,
      Constants.SortRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final ratingSlider = DiscoverSheetSlider(
      max: 4,
      min: 2,
      div: 2,
      initialValue: provider.rating,
    );

    final genres = Constants.GameGenreList.map(
      (e) => e.name,
    ).toList();
    genres.removeAt(0);
    final genreList = DiscoverSheetList(
      Constants.GameGenreList.where(
        (element) => element.name == provider.genre,
      ).firstOrNull?.name,
      genres,
    );

    final platformList = DiscoverSheetList(
      Constants.GamePlatformRequests.where(
        (element) => element.request == provider.platform,
      ).firstOrNull?.name,
      Constants.GamePlatformRequests.map(
        (e) => e.name,
      ).toList(),
      iconList: Constants.GamePlatformIcons,
    );

    final publishersList = DiscoverSheetImageList(
      Constants.GamePopularPublishersList.where(
          (element) => element.request == provider.publisher).firstOrNull?.name,
      Constants.GamePopularPublishersList.map(
        (e) => e.name,
      ).toList(),
      Constants.GamePopularPublishersList.map(
        (e) => e.image,
      ).toList(),
    );

    return SafeArea(
      child: Container(
        color: cupertinoTheme.bgColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 6,
                right: 6,
                top: 8,
                bottom: 6,
              ),
              child: Row(
                children: [
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: CupertinoColors.destructiveRed,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      provider.reset();
                      fetchData(true);
                    },
                  ),
                  CupertinoButton.filled(
                    onPressed: () {
                      Navigator.pop(context);

                      final newSort = Constants.SortRequests.where(
                        (element) =>
                            element.name ==
                            sortList.selectedValueNotifier.value!,
                      ).first.request;

                      final newPublisher =
                          Constants.GamePopularPublishersList.where(
                        (element) =>
                            element.name == publishersList.selectedValue,
                      ).firstOrNull?.request;

                      final newGenre = Constants.GameGenreList.where(
                        (element) =>
                            element.name ==
                            genreList.selectedValueNotifier.value,
                      ).firstOrNull?.name;

                      final newPlatform = Constants.GamePlatformRequests.where(
                        (element) =>
                            element.name ==
                            platformList.selectedValueNotifier.value,
                      ).firstOrNull?.request;

                      final shouldFetchData = provider.sort != newSort ||
                          provider.genre != newGenre ||
                          provider.platform != newPlatform ||
                          provider.publisher != newPublisher ||
                          ratingSlider.valueNotifier.value != provider.rating;

                      provider.setDiscover(
                        sort: newSort,
                        genre: newGenre,
                        platform: newPlatform,
                        publisher: newPublisher,
                        rating: ratingSlider.valueNotifier.value,
                      );

                      if (shouldFetchData) {
                        fetchData(true);
                      }
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: cupertinoTheme.bgTextColor.withValues(
                alpha: 0.1,
              ),
              height: 1,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DiscoverSheetFilterBody("Sort", sortList),
                    ratingSlider,
                    ChangeNotifierProvider(
                        create: (_) => StreamingPlatformStateProvider(),
                        child: DiscoverSheetImageFilterBody(
                          "Publishers",
                          publishersList,
                        )),
                    DiscoverSheetFilterBody("Genre", genreList),
                    DiscoverSheetFilterBody("Platforms", platformList),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 3)
          ],
        ),
      ),
    );
  }
}
