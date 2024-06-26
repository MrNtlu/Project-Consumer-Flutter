import 'package:watchlistfy/models/main/base_details.dart';

class TVWatchList extends BaseUserList {
  @override
  final String id;
  @override
  final String contentID;
  @override
  final String externalID;
  @override
  int timesFinished;
  @override
  String status;
  @override
  final String createdAt;
  @override
  int? score;
  @override 
  int? watchedEpisodes;
  @override 
  int? watchedSeasons;

  @override final int? externalIntID = null;

  TVWatchList(
    this.id, this.contentID, this.externalID, this.timesFinished,
    this.status, this.createdAt, this.score, 
    this.watchedEpisodes, this.watchedSeasons,
  );
}