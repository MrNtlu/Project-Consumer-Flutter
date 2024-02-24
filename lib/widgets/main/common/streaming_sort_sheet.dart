import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class StreamingSortSheet extends StatelessWidget {
  final String _currentSort;
  final Function(String) _setSort;

  const StreamingSortSheet(this._currentSort, this._setSort, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortRequestsStreamingPlatform.where(
        (element) => element.request == _currentSort
      ).first.name,
      Constants.SortRequestsStreamingPlatform.map((e) => e.name).toList(),
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
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
                final newSort = Constants.SortRequestsStreamingPlatform.where((element) => element.name == sortList.selectedValue!).first.request;
                _setSort(newSort);
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