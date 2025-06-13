import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/movie/movie_watch_list_body.dart';
import 'package:watchlistfy/models/main/movie/movie_watch_list_update_body.dart';
import 'package:watchlistfy/providers/main/details_sheet_provider.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_details_sheet.dart';
import 'package:watchlistfy/widgets/main/common/enhanced_sheet_textfield.dart';

class MovieWatchListSheet extends StatefulWidget {
  final MovieDetailsProvider provider;
  final String movieID;
  final String movieTMDBId;
  final BaseUserList? userList;

  const MovieWatchListSheet(
    this.provider,
    this.movieID,
    this.movieTMDBId, {
    this.userList,
    super.key,
  });

  @override
  State<MovieWatchListSheet> createState() => _MovieWatchListSheetState();
}

class _MovieWatchListSheetState extends State<MovieWatchListSheet> {
  late final TextEditingController _timesFinishedTextController;
  final GlobalKey<EnhancedDetailsSheetState> _sheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _timesFinishedTextController = TextEditingController(
      text: widget.userList?.timesFinished.toString() ?? '1',
    );
  }

  @override
  void dispose() {
    _timesFinishedTextController.dispose();
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
      return "Please enter how many times you've watched this movie.";
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

    await widget.provider.createMovieWatchList(
      MovieWatchListBody(
        widget.movieID,
        widget.movieTMDBId,
        isFinished ? int.parse(_timesFinishedTextController.text.trim()) : null,
        scoreDropdown.selectedValue,
        provider.selectedStatus.request,
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

    await widget.provider.updateMovieWatchList(
      MovieWatchListUpdateBody(
        userList.id,
        isUpdatingScore,
        isUpdatingScore ? scoreDropdown.selectedValue : null,
        provider.selectedStatus.request,
        isFinished ? int.parse(_timesFinishedTextController.text.trim()) : null,
      ),
    );
  }

  List<Widget> _buildCustomFields() {
    return [
      Consumer<DetailsSheetProvider>(
        builder: (context, provider, child) {
          final showTimesFinished = provider.selectedStatus.request ==
              Constants.UserListStatus[1].request;

          if (!showTimesFinished) {
            return const SizedBox.shrink();
          }

          return EnhancedSheetTextfield(
            controller: _timesFinishedTextController,
            label: "Times Watched",
            hint: "How many times?",
            icon: CupertinoIcons.repeat,
            onIncrement: () {
              final currentValue =
                  int.tryParse(_timesFinishedTextController.text) ?? 0;
              _timesFinishedTextController.text = (currentValue + 1).toString();
            },
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedDetailsSheet(
      key: _sheetKey,
      title: widget.userList != null ? "Update Movie" : "Add Movie",
      userList: widget.userList,
      customFields: _buildCustomFields(),
      onSave: _handleSave,
      onUpdate: widget.userList != null ? _handleUpdate : null,
      validator: _validateFields,
    );
  }
}
