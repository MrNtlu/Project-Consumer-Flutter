import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/common/backend_request_mapper.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/static/constants.dart';

final statusColors = [Colors.green.shade600, CupertinoColors.activeBlue, CupertinoColors.systemRed];

class DetailsSheetStatus extends StatelessWidget {
  final DetailsSheetProvider _provider;

  const DetailsSheetStatus(this._provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<BackendRequestMapper>(
      backgroundColor: CupertinoColors.systemGrey2,
      thumbColor: statusColors[Constants.UserListStatus.indexOf(_provider.selectedStatus)],
      groupValue: _provider.selectedStatus,
      onValueChanged: (BackendRequestMapper? value) {
        if (value != null) {
          _provider.changeStatus(value);
        }
      },
      children: _segmentControls(),
    );
  }

  Map<BackendRequestMapper, Widget> _segmentControls() => <BackendRequestMapper, Widget>{
    Constants.UserListStatus[0]: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Active',
        style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w500),
      ),
    ),
    Constants.UserListStatus[1]: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Finished',
        style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w500),
      ),
    ),
    Constants.UserListStatus[2]: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Dropped',
        style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w500),
      ),
    ),
  };
}
