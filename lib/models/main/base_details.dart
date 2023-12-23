import 'package:watchlistfy/models/main/common/consume_later.dart';

abstract class DetailsModel {
  abstract BaseUserList? userList;
  abstract ConsumeLater? consumeLater;
}

abstract class BaseUserList {
  abstract final String id;
  abstract final String contentID;
  abstract final String externalID;
  abstract int timesFinished;
  abstract String status;
  abstract final String createdAt;
  abstract int? score;

  abstract int? watchedEpisodes;
  abstract int? watchedSeasons;
}
