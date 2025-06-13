import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/game/game_play_list_body.dart';
import 'package:watchlistfy/models/main/game/game_play_list_update_body.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/providers/main/game/game_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_details_sheet.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_sheet_textfield.dart';

class GameDetailsPlayListSheet extends StatefulWidget {
  final GameDetailsProvider provider;
  final String gameID;
  final int gameRAWGId;
  final BaseUserList? userList;

  const GameDetailsPlayListSheet(this.provider, this.gameID, this.gameRAWGId,
      {this.userList, super.key});

  @override
  State<GameDetailsPlayListSheet> createState() =>
      _GameDetailsPlayListSheetState();
}

class _GameDetailsPlayListSheetState extends State<GameDetailsPlayListSheet> {
  late final TextEditingController _timesFinishedTextController;
  late final TextEditingController _hoursPlayedTextController;
  final GlobalKey<EnhancedDetailsSheetState> _sheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _timesFinishedTextController = TextEditingController(
      text: widget.userList?.timesFinished.toString() ?? '1',
    );
    _hoursPlayedTextController = TextEditingController(
      text: widget.userList?.watchedEpisodes?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _timesFinishedTextController.dispose();
    _hoursPlayedTextController.dispose();
    super.dispose();
  }

  String? _validateFields() {
    final provider = _sheetKey.currentState?.provider;
    if (provider == null) return "Invalid state";

    final isFinished =
        provider.selectedStatus.request == Constants.UserListStatus[1].request;
    final isTimesFinishedEmpty =
        _timesFinishedTextController.text.trim().isEmpty;

    if (isFinished && isTimesFinishedEmpty) {
      return "Please enter how many times you've completed this game.";
    }

    return null;
  }

  Future<void> _handleSave() async {
    final provider = _sheetKey.currentState?.provider;
    final scoreDropdown = _sheetKey.currentState?.scoreDropdown;

    if (provider == null || scoreDropdown == null) {
      throw Exception("Invalid state");
    }

    final isFinished =
        provider.selectedStatus.request == Constants.UserListStatus[1].request;

    await widget.provider.createGamePlayList(
      GamePlayListBody(
        widget.gameID,
        widget.gameRAWGId,
        isFinished ? int.parse(_timesFinishedTextController.text.trim()) : null,
        scoreDropdown.selectedValue,
        provider.selectedStatus.request,
        _hoursPlayedTextController.text.trim().isEmpty
            ? null
            : int.parse(_hoursPlayedTextController.text.trim()),
      ),
    );
  }

  Future<void> _handleUpdate() async {
    final provider = _sheetKey.currentState?.provider;
    final scoreDropdown = _sheetKey.currentState?.scoreDropdown;

    if (provider == null || scoreDropdown == null || widget.userList == null) {
      throw Exception("Invalid state");
    }

    final userList = widget.userList!;
    final isFinished =
        provider.selectedStatus.request == Constants.UserListStatus[1].request;
    final isUpdatingScore = userList.score != scoreDropdown.selectedValue;

    await widget.provider.updateGamePlayList(
      GamePlayListUpdateBody(
        userList.id,
        isUpdatingScore,
        isUpdatingScore ? scoreDropdown.selectedValue : null,
        provider.selectedStatus.request,
        isFinished ? int.parse(_timesFinishedTextController.text.trim()) : null,
        _hoursPlayedTextController.text.trim().isEmpty
            ? userList.watchedEpisodes
            : int.parse(_hoursPlayedTextController.text.trim()),
      ),
    );
  }

  List<Widget> _buildCustomFields() {
    return [
      // Hours Played Field
      EnhancedSheetTextfield(
        controller: _hoursPlayedTextController,
        label: "Hours Played",
        hint: "Total playtime",
        icon: CupertinoIcons.time,
        onIncrement: () {
          final currentValue =
              int.tryParse(_hoursPlayedTextController.text) ?? 0;
          _hoursPlayedTextController.text = (currentValue + 1).toString();
        },
      ),

      // Times Finished (conditional)
      Consumer<DetailsSheetProvider>(
        builder: (context, provider, child) {
          final showTimesFinished = provider.selectedStatus.request ==
              Constants.UserListStatus[1].request;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: showTimesFinished ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: showTimesFinished ? 1.0 : 0.0,
              child: showTimesFinished
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        EnhancedSheetTextfield(
                          controller: _timesFinishedTextController,
                          label: "Times Completed",
                          hint: "How many times?",
                          icon: CupertinoIcons.repeat,
                          onIncrement: () {
                            final currentValue = int.tryParse(
                                    _timesFinishedTextController.text) ??
                                0;
                            _timesFinishedTextController.text =
                                (currentValue + 1).toString();
                          },
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedDetailsSheet(
      key: _sheetKey,
      title: widget.userList != null ? "Update Game" : "Add Game",
      userList: widget.userList,
      customFields: _buildCustomFields(),
      onSave: _handleSave,
      onUpdate: widget.userList != null ? _handleUpdate : null,
      validator: _validateFields,
    );
  }
}
