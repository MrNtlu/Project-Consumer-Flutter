import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list_body.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list_update_body.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_details_sheet.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_sheet_textfield.dart';

class TVWatchListSheet extends StatefulWidget {
  final TVDetailsProvider provider;
  final String tvID;
  final String tvTMDBId;
  final int? episodePrefix;
  final int? seasonPrefix;
  final BaseUserList? userList;

  const TVWatchListSheet(this.provider, this.tvID, this.tvTMDBId,
      {this.userList, this.episodePrefix, this.seasonPrefix, super.key});

  @override
  State<TVWatchListSheet> createState() => TVWatchListSheetState();
}

class TVWatchListSheetState extends State<TVWatchListSheet> {
  late final TextEditingController _timesFinishedTextController;
  late final TextEditingController _timesWatchedTextController;
  late final TextEditingController _seasonTextController;
  late final TextEditingController _episodeTextController;
  final GlobalKey<EnhancedDetailsSheetState> _sheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _timesFinishedTextController = TextEditingController(
      text: widget.userList?.timesFinished.toString() ?? '1',
    );
    _timesWatchedTextController = TextEditingController(
      text: widget.userList?.timesFinished.toString() ?? '1',
    );
    _episodeTextController = TextEditingController(
      text: widget.userList?.watchedEpisodes.toString() ?? '0',
    );
    _seasonTextController = TextEditingController(
      text: widget.userList?.watchedSeasons.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _timesFinishedTextController.dispose();
    _timesWatchedTextController.dispose();
    _episodeTextController.dispose();
    _seasonTextController.dispose();
    super.dispose();
  }

  String? _validateFields() {
    final provider = _sheetKey.currentState?.provider;
    if (provider == null) return "Invalid state";

    final isFinished =
        provider.selectedStatus.request == Constants.UserListStatus[1].request;
    final isTimesWatchedEmpty = _timesWatchedTextController.text.trim().isEmpty;
    final isEpisodesEmpty = _episodeTextController.text.trim().isEmpty;
    final isSeasonsEmpty = _seasonTextController.text.trim().isEmpty;

    if (isEpisodesEmpty || isSeasonsEmpty) {
      return "Please enter your progress for seasons and episodes.";
    }

    if (isFinished && isTimesWatchedEmpty) {
      return "Please enter how many times you've watched this series.";
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

    await widget.provider.createTVWatchList(
      TVWatchListBody(
        widget.tvID,
        widget.tvTMDBId,
        isFinished ? int.parse(_timesWatchedTextController.text.trim()) : null,
        scoreDropdown.selectedValue,
        provider.selectedStatus.request,
        _episodeTextController.text.trim().isEmpty
            ? null
            : int.parse(_episodeTextController.text.trim()),
        _seasonTextController.text.trim().isEmpty
            ? null
            : int.parse(_seasonTextController.text.trim()),
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

    await widget.provider.updateTVWatchList(
      TVWatchListUpdateBody(
        userList.id,
        isUpdatingScore,
        isUpdatingScore ? scoreDropdown.selectedValue : null,
        provider.selectedStatus.request,
        isFinished ? int.parse(_timesWatchedTextController.text.trim()) : null,
        _episodeTextController.text.trim().isEmpty
            ? userList.watchedEpisodes
            : int.parse(_episodeTextController.text.trim()),
        _seasonTextController.text.trim().isEmpty
            ? userList.watchedSeasons
            : int.parse(_seasonTextController.text.trim()),
      ),
    );
  }

  List<Widget> _buildCustomFields() {
    return [
      // Seasons Field
      EnhancedSheetTextfield(
        controller: _seasonTextController,
        label: "Seasons Watched",
        hint: "Number of seasons",
        icon: CupertinoIcons.tv,
        suffix: widget.seasonPrefix?.toString(),
        onIncrement: () {
          final currentValue = int.tryParse(_seasonTextController.text) ?? 0;
          _seasonTextController.text = (currentValue + 1).toString();
        },
      ),

      const SizedBox(height: 20),

      // Episodes Field
      EnhancedSheetTextfield(
        controller: _episodeTextController,
        label: "Episodes Watched",
        hint: "Number of episodes",
        icon: CupertinoIcons.play_circle,
        suffix: widget.episodePrefix?.toString(),
        onIncrement: () {
          final currentValue = int.tryParse(_episodeTextController.text) ?? 0;
          _episodeTextController.text = (currentValue + 1).toString();
        },
      ),

      // Times Watched (only when finished)
      Consumer<DetailsSheetProvider>(
        builder: (context, provider, child) {
          final isFinished = provider.selectedStatus.request ==
              Constants.UserListStatus[1].request;

          if (!isFinished) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              EnhancedSheetTextfield(
                controller: _timesWatchedTextController,
                label: "Times Watched",
                hint: "How many times?",
                icon: CupertinoIcons.repeat,
                onIncrement: () {
                  final currentValue =
                      int.tryParse(_timesWatchedTextController.text) ?? 0;
                  _timesWatchedTextController.text =
                      (currentValue + 1).toString();
                },
              ),
            ],
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedDetailsSheet(
      key: _sheetKey,
      title: widget.userList != null ? "Update TV Show" : "Add TV Show",
      userList: widget.userList,
      customFields: _buildCustomFields(),
      onSave: _handleSave,
      onUpdate: widget.userList != null ? _handleUpdate : null,
      validator: _validateFields,
    );
  }
}
