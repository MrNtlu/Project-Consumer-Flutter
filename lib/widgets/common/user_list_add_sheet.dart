import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/common/backend_request_mapper.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/score_dropdown.dart';

class UserListAddSheet extends StatefulWidget {
  final BaseUserList? userList;

  const UserListAddSheet({this.userList, super.key});

  @override
  State<UserListAddSheet> createState() => _UserListAddSheetState();
}

class _UserListAddSheetState extends State<UserListAddSheet> {
  BackendRequestMapper _selectedSegment = Constants.UserListStatus[0];
  late TextEditingController _timesFinishedTextController;

  final statusColors = [CupertinoColors.activeGreen, CupertinoColors.activeBlue, CupertinoColors.systemRed];

  @override
  void initState() {
    super.initState();
    _timesFinishedTextController = TextEditingController(text: widget.userList?.timesFinished.toString() ?? '');
  }

  @override
  void dispose() {
    _timesFinishedTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).onBgColor,
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [ //TODO Handle with provider
              CupertinoSlidingSegmentedControl<BackendRequestMapper>(
                backgroundColor: CupertinoColors.systemGrey2,
                thumbColor: statusColors[Constants.UserListStatus.indexOf(_selectedSegment)],
                groupValue: _selectedSegment,
                onValueChanged: (BackendRequestMapper? value) {
                  if (value != null) {
                    setState(() {
                      _selectedSegment = value;
                    });
                  }
                },
                children: <BackendRequestMapper, Widget>{
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
                },
              ),
              const SizedBox(height: 16),
              ScoreDropdown(),
              if (_selectedSegment.request == Constants.UserListStatus[1].request)
              const SizedBox(height: 12),
              if (_selectedSegment.request == Constants.UserListStatus[1].request)
              CupertinoTextField(
                controller: _timesFinishedTextController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                maxLines: 1,
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Times Finished",
                    style: TextStyle(color: CupertinoTheme.of(context).bgTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                textAlign: TextAlign.end,
                decoration: BoxDecoration(
                  color: CupertinoTheme.of(context).bgColor,
                  borderRadius: BorderRadius.circular(8)
                ),
                style: const TextStyle(fontSize: 16),
                padding: const EdgeInsets.all(8),
                suffix: CupertinoButton(
                  child: Icon(Icons.add_circle_rounded, color: CupertinoTheme.of(context).bgTextColor,), 
                  onPressed: () {
                    _timesFinishedTextController.text = (
                      int.parse(_timesFinishedTextController.text != "" ? _timesFinishedTextController.text : "0") + 1
                    ).toString();
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    child: const Text("Cancel", style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 14)), 
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                  CupertinoButton(
                    child: const Text("Save", style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold, fontSize: 16)), 
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
