import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class UserListSettingsSheet extends StatelessWidget {
  final VoidCallback _fetchData;
  final UserListContentSelectionProvider _provider;

  const UserListSettingsSheet(this._fetchData, this._provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);

    final sortList = DiscoverSheetList(
      Constants.SortUserListRequests.where(
          (element) => element.request == _provider.sort).first.name,
      Constants.SortUserListRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final uiList = DiscoverSheetList(
      Constants.UserListUIModes.where(
          (element) => element == globalProvider.userListMode).first,
      Constants.UserListUIModes,
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
          DiscoverSheetFilterBody("Mode", uiList),
          const SizedBox(height: 16),
          CupertinoButton(
            onPressed: () {
              Navigator.pop(context);
              final newSort = Constants.SortUserListRequests.where((element) =>
                      element.name == sortList.selectedValueNotifier.value!)
                  .first
                  .request;
              final newUIMode = Constants.UserListUIModes.where((element) =>
                  element == uiList.selectedValueNotifier.value!).first;
              final shouldFetchData = _provider.sort != newSort;

              _provider.setSort(newSort);
              globalProvider.setUserListMode(newUIMode);

              if (shouldFetchData) {
                _fetchData();
              }
            },
            child: const Text("Done",
                style: TextStyle(
                    color: CupertinoColors.systemBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          )
        ],
      ),
    ));
  }
}
