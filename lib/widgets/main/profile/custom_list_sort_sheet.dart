import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/profile/custom_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class CustomListSortSheet extends StatelessWidget {
  final VoidCallback _fetchData;
  final CustomListProvider _provider;

  const CustomListSortSheet(this._fetchData, this._provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortCustomListRequests.where(
        (element) => element.request == _provider.sort
      ).first.name,
      Constants.SortCustomListRequests.map((e) => e.name).toList(),
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
                final newSort = Constants.SortCustomListRequests.where((element) => element.name == sortList.selectedValue!).first.request;
                final shouldFetchData = _provider.sort != newSort;

                _provider.sort = newSort;

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