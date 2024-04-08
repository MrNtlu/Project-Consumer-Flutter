import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list_update_body.dart';
import 'package:watchlistfy/models/main/game/game_play_list_update_body.dart';
import 'package:watchlistfy/models/main/movie/movie_watch_list_update_body.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list_update_body.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/score_dropdown.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_buttons.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_status.dart';
import 'package:watchlistfy/widgets/main/common/details_sheet_textfield.dart';

class UserListEditSheet extends StatefulWidget {
  final int index;
  final UserListProvider provider;
  final ContentType contentType;
  final UserListContent userList;

  const UserListEditSheet(
    this.index,
    this.provider,
    this.contentType,
    this.userList,
    {super.key}
  );

  @override
  State<UserListEditSheet> createState() => _UserListEditSheetState();
}

class _UserListEditSheetState extends State<UserListEditSheet> {
  late TextEditingController _timesFinishedTextController;
  late TextEditingController _seasonTextController;
  late TextEditingController _episodeTextController;
  late ScoreDropdown _scoreDropdown;
  late final DetailsSheetProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = DetailsSheetProvider();
    _provider.initStatus(Constants.UserListStatus.firstWhere((element) => element.request == widget.userList.status));
    _scoreDropdown = ScoreDropdown(
      selectedValue: widget.userList.score,
    );
    _timesFinishedTextController = TextEditingController(text: widget.userList.timesFinished.toString());
    _episodeTextController = TextEditingController(text: widget.userList.watchedEpisodes.toString());
    _seasonTextController = TextEditingController(text: widget.userList.watchedSeasons.toString());
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
                    if (widget.contentType == ContentType.tv)
                    DetailsSheetTextfield(
                      _seasonTextController, 
                      text: "Seasons", 
                      onPressed: () {
                        _seasonTextController.text = (
                          int.parse(_seasonTextController.text != "" ? _seasonTextController.text : "0") + 1
                        ).toString();
                      },
                      suffix: widget.userList.totalSeasons?.toString(),
                    ),
                    if (widget.contentType == ContentType.tv)
                    const SizedBox(height: 12),
                    if (widget.contentType != ContentType.movie)
                    DetailsSheetTextfield(
                      _episodeTextController, 
                      text: widget.contentType != ContentType.game ? "Episodes" : "Hours Played",
                      onPressed: () {
                        _episodeTextController.text = (
                          int.parse(_episodeTextController.text != "" ? _episodeTextController.text : "0") + 1
                        ).toString();
                      },
                      suffix: widget.userList.totalEpisodes?.toString(),
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
                      text: "Update",
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

                          final userList = widget.userList;
                          final isUpdatingScore = userList.score != _scoreDropdown.selectedValue;
                          final score = isUpdatingScore ? _scoreDropdown.selectedValue : null;
                          final timesFinished = isFinished ? int.parse(_timesFinishedTextController.value.text) : null;
                          final status = provider.selectedStatus.request;
                          final episodeText = (
                            _episodeTextController.value.text == "" || 
                            widget.contentType == ContentType.movie
                          ) ? userList.watchedEpisodes : int.parse(_episodeTextController.value.text);
                          final seasonText = (
                            _seasonTextController.value.text == "" ||
                            widget.contentType != ContentType.tv 
                          )? userList.watchedSeasons : int.parse(_seasonTextController.value.text);

                          late final JSONConverter request;
                          switch (widget.contentType) {
                            case ContentType.anime:
                              request = AnimeWatchListUpdateBody(userList.id, isUpdatingScore, score, status, timesFinished, episodeText);
                              break;
                            case ContentType.game:
                              request = GamePlayListUpdateBody(userList.id, isUpdatingScore, score, status, timesFinished, episodeText);
                              break;
                            case ContentType.tv:
                              request = TVWatchListUpdateBody(userList.id, isUpdatingScore, score, status, timesFinished, episodeText, seasonText);
                              break;
                            default:
                              request = MovieWatchListUpdateBody(userList.id, isUpdatingScore, score, status, timesFinished);
                          }
                          widget.provider.updateUserList(widget.index, request, widget.contentType);
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
