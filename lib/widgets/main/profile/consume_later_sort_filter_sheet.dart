import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/discover/discover_streaming_provider.dart';
import 'package:watchlistfy/providers/main/profile/consume_later_sort_filter_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_image_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class ConsumeLaterSortFilterSheet extends StatelessWidget {
  final VoidCallback _fetchData;
  final ConsumeLaterSortFilterProvider _provider;

  const ConsumeLaterSortFilterSheet(this._fetchData, this._provider, {super.key});

  List<String> combineUniqueLists<String>(List<List<String>> lists) {
   final Set<String> uniqueValues = <String>{};

    for (List<String> list in lists) {
      uniqueValues.addAll(list);
    }

    return uniqueValues.toList();
  }

  @override
  Widget build(BuildContext context) {
    final filterList = DiscoverSheetList(
      ContentType.values.where(
        (element) => element == _provider.filterContent
      ).firstOrNull?.value,
      ContentType.values.map((e) => e.value).toList(),
    );

    final combinedGenres = combineUniqueLists(
      [
        Constants.MovieGenreList.map((e) => e.name).toList(),
        Constants.GameGenreList.map((e) => e.name).toList(),
        Constants.AnimeGenreList.map((e) => e.name).toList(),
      ]
    );
    combinedGenres.removeAt(0);

    final genreList = DiscoverSheetList(
      combinedGenres.where(
        (element) => element == _provider.genre
      ).firstOrNull,
      combinedGenres,
    );

    final streamingPlatformList = DiscoverSheetImageList(
      Constants.StreamingPlatformList.where(
        (element) => element.request == _provider.streaming
      ).firstOrNull?.name,
      Constants.StreamingPlatformList.map((e) => e.name).toList(),
      Constants.StreamingPlatformList.map((e) => e.image).toList(),
    );

    final sortList = DiscoverSheetList(
      Constants.SortConsumeLaterRequests.where(
        (element) => element.request == _provider.sort
      ).first.name,
      Constants.SortConsumeLaterRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    return SafeArea(
      child: ColoredBox(
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DiscoverSheetFilterBody("Sort", sortList),
                    DiscoverSheetFilterBody("Type", filterList),
                    DiscoverSheetFilterBody("Genre", genreList),
                    ChangeNotifierProvider(
                      create: (_) => StreamingPlatformStateProvider(),
                      child: DiscoverSheetImageFilterBody("Streaming Platforms", streamingPlatformList)
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  child: const Text("Reset", style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 14)),
                  onPressed: () {
                    Navigator.pop(context);

                    _provider.reset();
                    _fetchData();
                  }
                ),
                CupertinoButton.filled(
                  onPressed: () {
                    Navigator.pop(context);

                    final newSort = Constants.SortConsumeLaterRequests.where((element) => element.name == sortList.selectedValue!).first.request;
                    final newFilter = ContentType.values.where((element) => element.value == filterList.selectedValue).firstOrNull;
                    final newGenre = combinedGenres.where((element) => element == genreList.selectedValue).firstOrNull;
                    final newStreaming = Constants.StreamingPlatformList.where((element) => element.name == streamingPlatformList.selectedValue).firstOrNull?.request;

                    final shouldFetchData = _provider.sort != newSort
                      || _provider.filterContent != newFilter
                      || _provider.genre != newGenre
                      || _provider.streaming != newStreaming;

                    _provider.setSort(newSort);
                    _provider.setContentType(newFilter);
                    _provider.setGenre(newGenre);
                    _provider.setStreamingPlatform(newStreaming);

                    if (shouldFetchData) {
                      _fetchData();
                    }
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                )
              ],
            ),
            const SizedBox(height: 6)
          ],
        ),
      )
    );
  }
}