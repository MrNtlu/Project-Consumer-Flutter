import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list_body.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list_update_body.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/providers/main/anime/anime_details_provider.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_details_sheet.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_sheet_textfield.dart';

class AnimeWatchListSheet extends StatefulWidget {
  final AnimeDetailsProvider provider;
  final String animeID;
  final int animeMALId;
  final int? episodePrefix;
  final BaseUserList? userList;

  const AnimeWatchListSheet(this.provider, this.animeID, this.animeMALId,
      {this.userList, this.episodePrefix, super.key});

  @override
  State<AnimeWatchListSheet> createState() => _AnimeWatchListSheetState();
}

class _AnimeWatchListSheetState extends State<AnimeWatchListSheet> {
  late final TextEditingController _timesFinishedTextController;
  late final TextEditingController _episodeTextController;
  final GlobalKey<EnhancedDetailsSheetState> _sheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _timesFinishedTextController = TextEditingController(
      text: widget.userList?.timesFinished.toString() ?? '1',
    );
    _episodeTextController = TextEditingController(
      text: widget.userList?.watchedEpisodes.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _timesFinishedTextController.dispose();
    _episodeTextController.dispose();
    super.dispose();
  }

  String? _validateFields() {
    final provider = _sheetKey.currentState?.provider;
    if (provider == null) return "Invalid state";

    final isFinished =
        provider.selectedStatus.request == Constants.UserListStatus[1].request;
    final isTimesFinishedEmpty =
        _timesFinishedTextController.text.trim().isEmpty;
    final isEpisodesEmpty = _episodeTextController.text.trim().isEmpty;

    if (isEpisodesEmpty) {
      return "Please enter your episode progress.";
    }

    if (isFinished && isTimesFinishedEmpty) {
      return "Please enter how many times you've completed this anime.";
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

    await widget.provider.createAnimeWatchList(
      AnimeWatchListBody(
        widget.animeID,
        widget.animeMALId,
        isFinished ? int.parse(_timesFinishedTextController.text.trim()) : null,
        scoreDropdown.selectedValue,
        provider.selectedStatus.request,
        _episodeTextController.text.trim().isEmpty
            ? null
            : int.parse(_episodeTextController.text.trim()),
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

    await widget.provider.updateAnimeWatchList(
      AnimeWatchListUpdateBody(
        userList.id,
        isUpdatingScore,
        isUpdatingScore ? scoreDropdown.selectedValue : null,
        provider.selectedStatus.request,
        isFinished ? int.parse(_timesFinishedTextController.text.trim()) : null,
        _episodeTextController.text.trim().isEmpty
            ? userList.watchedEpisodes
            : int.parse(_episodeTextController.text.trim()),
      ),
    );
  }

  List<Widget> _buildCustomFields() {
    return [
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
      title: widget.userList != null ? "Update Anime" : "Add Anime",
      userList: widget.userList,
      customFields: _buildCustomFields(),
      onSave: _handleSave,
      onUpdate: widget.userList != null ? _handleUpdate : null,
      validator: _validateFields,
    );
  }
}
