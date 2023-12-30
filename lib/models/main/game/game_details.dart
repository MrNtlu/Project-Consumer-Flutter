import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/review_summary.dart';
import 'package:watchlistfy/models/main/game/game_details_relation.dart';
import 'package:watchlistfy/models/main/game/game_details_store.dart';
import 'package:watchlistfy/models/main/game/game_play_list.dart';

class GameDetails extends DetailsModel<GamePlayList> {
  final String id;
  final String description;
  final bool tba;
  final String? subreddit;
  final List<String> genres;
  final List<String> tags;
  final List<String> platforms;
  final List<String> developers;
  final List<String> publishers;
  final List<GameDetailsStore> stores;
  final List<String> screenshots;
  final ReviewSummary reviewSummary;
  final String title;
  final String titleOriginal;
  final String imageUrl;
  final int rawgId;
  final double rawgRating;
  final int rawgRatingCount;
  final int? metacriticScore;
  final String? releaseDate;
  final String? ageRating;
  final List<GameDetailsRelation> relatedGames;

  @override
  GamePlayList? userList;
  @override
  ConsumeLater? consumeLater;

  GameDetails(
    this.id, this.description, this.tba, this.subreddit,
    this.genres, this.tags, this.platforms, this.developers,
    this.publishers, this.stores, this.screenshots, this.reviewSummary,
    this.title, this.titleOriginal, this.imageUrl, this.rawgId,
    this.rawgRating, this.rawgRatingCount, this.metacriticScore,
    this.releaseDate, this.ageRating, this.relatedGames, 
    this.userList, this.consumeLater,
  );
}