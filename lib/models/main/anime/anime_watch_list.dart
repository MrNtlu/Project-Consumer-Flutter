import 'package:watchlistfy/models/main/base_details.dart';

class AnimeWatchList extends BaseUserList {
  @override
  final String id;
  @override
  final String contentID;
  @override 
  final int? externalIntID;
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
  
  @override final String? externalID = null;
  @override int? watchedSeasons;

  AnimeWatchList(
    this.id, this.contentID, this.externalIntID, this.timesFinished,
    this.status, this.createdAt, this.score, this.watchedEpisodes, 
  );
}