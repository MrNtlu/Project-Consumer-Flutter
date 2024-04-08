import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list_body.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list_update_body.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/providers/main/tv/tv_details_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/score_dropdown.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_buttons.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_status.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_textfield.dart';

class TVWatchListSheet extends StatefulWidget {
  final TVDetailsProvider provider;
  final String tvID;
  final String tvTMDBId;
  final int? episodePrefix;
  final int? seasonPrefix;
  final BaseUserList? userList;

  const TVWatchListSheet(
    this.provider, this.tvID, 
    this.tvTMDBId,
    {this.userList, this.episodePrefix, this.seasonPrefix, super.key}
  );

  @override
  State<TVWatchListSheet> createState() => TVWatchListSheetState();
}

class TVWatchListSheetState extends State<TVWatchListSheet> {
  late TextEditingController _timesFinishedTextController;
  late TextEditingController _seasonTextController;
  late TextEditingController _episodeTextController;
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
    _episodeTextController = TextEditingController(text: widget.userList?.watchedEpisodes.toString() ?? '0');
    _seasonTextController = TextEditingController(text: widget.userList?.watchedSeasons.toString() ?? '0');
  }

  @override
  void dispose() {
    _timesFinishedTextController.dispose();
    _episodeTextController.dispose();
    _seasonTextController.dispose();
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
                      _seasonTextController, 
                      text: "Seasons", 
                      onPressed: () {
                        _seasonTextController.text = (
                          int.parse(_seasonTextController.text != "" ? _seasonTextController.text : "0") + 1
                        ).toString();
                      },
                      suffix: widget.seasonPrefix?.toString(),
                    ),
                    const SizedBox(height: 12),
                    DetailsSheetTextfield(
                      _episodeTextController, 
                      text: "Episodes",
                      onPressed: () {
                        _episodeTextController.text = (
                          int.parse(_episodeTextController.text != "" ? _episodeTextController.text : "0") + 1
                        ).toString();
                      },
                      suffix: widget.episodePrefix?.toString(),
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
                        final isEpisodesEmpty = _episodeTextController.text == "";
                        final isSeasonsEmpty = _seasonTextController.text == "";
          
                        if ((isFinished && isTimesFinishedEmpty) || isEpisodesEmpty || isSeasonsEmpty) {
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
          
                            widget.provider.updateTVWatchList(TVWatchListUpdateBody(
                              userList.id, isUpdatingScore, 
                              isUpdatingScore ? _scoreDropdown.selectedValue : null, 
                              provider.selectedStatus.request,
                              isFinished ? int.parse(_timesFinishedTextController.value.text) : null,
                              _episodeTextController.value.text == "" ? userList.watchedEpisodes : int.parse(_episodeTextController.value.text),
                              _seasonTextController.value.text == "" ? userList.watchedSeasons : int.parse(_seasonTextController.value.text)
                            ));
                          } else {
                            widget.provider.createTVWatchList(TVWatchListBody(
                              widget.tvID, widget.tvTMDBId, 
                              isFinished ? int.parse(_timesFinishedTextController.value.text) : null,
                              _scoreDropdown.selectedValue, 
                              provider.selectedStatus.request,
                              _episodeTextController.value.text == "" ? null : int.parse(_episodeTextController.value.text),
                              _seasonTextController.value.text == "" ? null : int.parse(_seasonTextController.value.text)
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
