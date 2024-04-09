import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/main/discover/discover_game_provider.dart';
import 'package:watchlistfy/providers/main/discover/discover_streaming_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_image_list.dart';
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

    final publishersList = DiscoverSheetImageList(
      Constants.GamePopularPublishersList.where(
        (element) => element.request == provider.publisher
      ).firstOrNull?.name,
      Constants.GamePopularPublishersList.map((e) => e.name).toList(),
      Constants.GamePopularPublishersList.map((e) => e.image).toList(),
    );

    return SafeArea(
      child: Container(
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
                        ChangeNotifierProvider(
                          create: (_) => StreamingPlatformStateProvider(),
                          child: DiscoverSheetImageFilterBody("Publishers", publishersList)
                        ),
                        DiscoverSheetFilterBody("Genre", genreList),
                        DiscoverSheetFilterBody("Platforms", platformList),
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
                                final newPublisher = Constants.GamePopularPublishersList.where((element) => element.name == publishersList.selectedValue).firstOrNull?.request;
                                final newGenre = Constants.GameGenreList.where((element) => element.name == genreList.selectedValue).firstOrNull?.name;
                                final newPlatform = Constants.GamePlatformRequests.where((element) => element.name == platformList.selectedValue).firstOrNull?.request;

                                final shouldFetchData = provider.sort != newSort
                                  || provider.genre != newGenre
                                  || provider.platform != newPlatform
                                  || provider.publisher != newPublisher;

                                provider.setDiscover(
                                  sort: newSort,
                                  genre: newGenre,
                                  platform: newPlatform,
                                  publisher: newPublisher,
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
            const SizedBox(height: 3)
          ],
        ),
      ),
    );
  }
}