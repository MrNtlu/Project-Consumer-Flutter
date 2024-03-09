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

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortConsumeLaterRequests.where(
        (element) => element.request == _provider.sort
      ).first.name,
      Constants.SortConsumeLaterRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final filterList = DiscoverSheetList(
      ContentType.values.where(
        (element) => element == _provider.filterContent
      ).firstOrNull?.value,
      ContentType.values.map((e) => e.value).toList(),
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
            DiscoverSheetFilterBody("Filter", filterList),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
                final newSort = Constants.SortConsumeLaterRequests.where((element) => element.name == sortList.selectedValue!).first.request;
                final newFilter = ContentType.values.where((element) => element.value == filterList.selectedValue).firstOrNull;
                final shouldFetchData = _provider.sort != newSort || _provider.filterContent != newFilter;

                _provider.setSort(newSort);
                _provider.setContentType(newFilter);

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