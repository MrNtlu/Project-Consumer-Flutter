import 'package:watchlistfy/models/main/base_details.dart';

class UserListContent extends BaseUserList {
  bool isLoading = false;

  @override 
  final String id;
  @override
  String status;
  @override
  int? score;
  @override
  int timesFinished;
  @override
  int? watchedEpisodes;
  @override
  int? watchedSeasons;

  final int? totalEpisodes;
  final int? totalSeasons;
  @override
  final String contentID;
  @override
  final String externalID;
  final String? imageUrl;
  final String title;
  final String titleOriginal;
  @override
  final String createdAt;

  @override final int? externalIntID = null;

  UserListContent(
    this.id,
    this.status,
    this.score,
    this.timesFinished,
    this.watchedEpisodes,
    this.watchedSeasons,
    this.totalEpisodes,
    this.totalSeasons,
    this.contentID,
    this.externalID,
    this.imageUrl,
    this.title,
    this.titleOriginal,
    this.createdAt
  );

  void changeUserList(int? score, int timesFinished, int? mainAttribute, int? extraAttribute) {
    this.score = score;
    this.timesFinished = timesFinished;
    watchedEpisodes = mainAttribute;
    watchedSeasons = extraAttribute;
    isLoading = false;
  }
}
