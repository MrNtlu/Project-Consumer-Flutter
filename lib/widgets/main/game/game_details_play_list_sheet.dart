import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/game/game_play_list_body.dart';
import 'package:watchlistfy/models/main/game/game_play_list_update_body.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/providers/main/game/game_details_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/score_dropdown.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_buttons.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_status.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_textfield.dart';

class GameDetailsPlayListSheet extends StatefulWidget {
  final GameDetailsProvider provider;
  final String gameID;
  final int gameRAWGId;
  final BaseUserList? userList;

  const GameDetailsPlayListSheet(
    this.provider, this.gameID,
    this.gameRAWGId,
    {this.userList, super.key}
  );

  @override
  State<GameDetailsPlayListSheet> createState() => _GameDetailsPlayListSheetState();
}

class _GameDetailsPlayListSheetState extends State<GameDetailsPlayListSheet> {
  late TextEditingController _timesFinishedTextController;
  late TextEditingController _hoursPlayedTextController;
  late ScoreDropdown _scoreDropdown;
  late final DetailsSheetProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = DetailsSheetProvider();
    if (widget.userList != null) {
      _provider.initStatus(Constants.UserListStatus.firstWhere((element) => element.request == widget.userList!.status));
    }
    _scoreDropdown = ScoreDropdown(
      selectedValue: widget.userList?.score,
    );
    _timesFinishedTextController = TextEditingController(text: widget.userList?.timesFinished.toString() ?? '1');
    _hoursPlayedTextController = TextEditingController(text: widget.userList?.watchedEpisodes?.toString() ?? '');
  }

  @override
  void dispose() {
    _timesFinishedTextController.dispose();
    _hoursPlayedTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<DetailsSheetProvider>(
        builder: (context, provider, child) {
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
                  children: [
                    DetailsSheetStatus(provider),
                    const SizedBox(height: 16),
                    _scoreDropdown,
                    const SizedBox(height: 12),
                    DetailsSheetTextfield(
                      _hoursPlayedTextController, 
                      text: "Hours Played",
                      onPressed: () {
                        _hoursPlayedTextController.text = (
                          int.parse(_hoursPlayedTextController.text != "" ? _hoursPlayedTextController.text : "0") + 1
                        ).toString();
                      },
                    ),
                    if (provider.selectedStatus.request == Constants.UserListStatus[1].request)
                    const SizedBox(height: 12),
                    if (provider.selectedStatus.request == Constants.UserListStatus[1].request)
                    DetailsSheetTextfield(
                      _timesFinishedTextController, 
                      text: "Times Finished", 
                      onPressed: () {
                        _timesFinishedTextController.text = (
                          int.parse(_timesFinishedTextController.text != "" ? _timesFinishedTextController.text : "0") + 1
                        ).toString();
                      }
                    ),
                    const SizedBox(height: 24),
                    DetailsSheetButtons(
                      text: widget.userList != null ? "Update" : "Save",
                      onPressed: () {
                        final isFinished = provider.selectedStatus.request == Constants.UserListStatus[1].request;
                        final isTimesFinishedEmpty = _timesFinishedTextController.text == "";
          
                        if (isFinished && isTimesFinishedEmpty) {
                          showCupertinoDialog(
                            context: context, 
                            builder: (context) {
                              return const ErrorDialog("Please fill the empty fields.");
                            }
                          );
                        } else {
                          Navigator.pop(context);
          
                          if (widget.userList != null) {
                            final userList = widget.userList!;
                            final isUpdatingScore = userList.score != _scoreDropdown.selectedValue;

                            widget.provider.updateGamePlayList(GamePlayListUpdateBody(
                              userList.id, isUpdatingScore, 
                              isUpdatingScore ? _scoreDropdown.selectedValue : null, 
                              provider.selectedStatus.request,
                              isFinished ? int.parse(_timesFinishedTextController.value.text) : null,
                              _hoursPlayedTextController.value.text == "" ? userList.watchedEpisodes : int.parse(_hoursPlayedTextController.value.text),
                            ));
                          } else {
                            widget.provider.createGamePlayList(GamePlayListBody(
                              widget.gameID, widget.gameRAWGId,
                              isFinished ? int.parse(_timesFinishedTextController.value.text) : null,
                              _scoreDropdown.selectedValue, 
                              provider.selectedStatus.request,
                              _hoursPlayedTextController.value.text == "" ? null : int.parse(_hoursPlayedTextController.value.text),
                            ));
                          }
                        }
                      }
                    ),
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }
}