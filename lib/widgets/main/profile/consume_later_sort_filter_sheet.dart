import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/profile/consume_later_sort_filter_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
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

    final sortList = DiscoverSheetList(
      Constants.SortConsumeLaterRequests.where(
        (element) => element.request == _provider.sort
      ).first.name,
      Constants.SortConsumeLaterRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
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
            DiscoverSheetFilterBody("Sort", sortList),
            DiscoverSheetFilterBody("Type", filterList),
            DiscoverSheetFilterBody("Genre", genreList),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
                final newSort = Constants.SortConsumeLaterRequests.where((element) => element.name == sortList.selectedValue!).first.request;
                final newFilter = ContentType.values.where((element) => element.value == filterList.selectedValue).firstOrNull;
                final newGenre = combinedGenres.where((element) => element == genreList.selectedValue).firstOrNull;

                final shouldFetchData = _provider.sort != newSort 
                  || _provider.filterContent != newFilter
                  || _provider.genre != newGenre;

                _provider.setSort(newSort);
                _provider.setContentType(newFilter);
                _provider.setGenre(newGenre);

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