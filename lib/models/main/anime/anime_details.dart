import 'package:watchlistfy/models/main/anime/anime_details_air_date.dart';
import 'package:watchlistfy/models/main/anime/anime_details_character.dart';
import 'package:watchlistfy/models/main/anime/anime_details_name_url.dart';
import 'package:watchlistfy/models/main/anime/anime_details_recommendation.dart';
import 'package:watchlistfy/models/main/anime/anime_details_relation.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/review_summary.dart';

class AnimeDetails extends DetailsModel<AnimeWatchList> {
  final String id;
  final String description;
  final String type;
  final String source;
  final int? episodes;
  final String? season;
  final int? year;
  final String status;
  final String? backdrop;
  final AnimeDetailsAirDate aired;
  final List<AnimeDetailsRecommendation> recommendations;
  final List<AnimeNameUrl>? streaming;
  final List<AnimeNameUrl>? producers;
  final List<AnimeNameUrl>? studios;
  final List<AnimeNameUrl>? genres;
  final List<AnimeNameUrl>? themes;
  final List<AnimeNameUrl>? demographics;
  final List<AnimeDetailsRelation> relations;
  final List<AnimeDetailsCharacter> characters;
  final ReviewSummary reviewSummary;
  final String title;
  final String titleJP;
  final String titleOriginal;
  final String imageUrl;
  final int malID;
  final double malScore;
  final int malScoredBy;
  final bool isAiring;
  final String? ageRating;
  final String? trailer;

  @override
  AnimeWatchList? userList;
  @override
  ConsumeLater? consumeLater;

  AnimeDetails(
    this.id, this.description, this.type, this.source,
    this.episodes, this.season, this.year, this.status,
    this.backdrop, this.aired, this.recommendations, this.streaming,
    this.producers, this.studios, this.genres, this.themes, this.demographics,
    this.relations, this.characters, this.reviewSummary, this.title,
    this.titleJP, this.titleOriginal, this.imageUrl, this.malID, this.malScore, this.malScoredBy,
    this.isAiring, this.ageRating, this.trailer, this.userList, this.consumeLater
  );
}