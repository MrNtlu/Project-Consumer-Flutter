import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/actor.dart';
import 'package:watchlistfy/models/main/common/production_company.dart';
import 'package:watchlistfy/models/main/common/recommendation.dart';
import 'package:watchlistfy/models/main/common/review_summary.dart';
import 'package:watchlistfy/models/main/common/streaming.dart';
import 'package:watchlistfy/models/main/tv/tv_details_network.dart';
import 'package:watchlistfy/models/main/tv/tv_details_season.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';

class TVDetails extends DetailsModel<TVWatchList> {
  final String id;
  final String description;
  final List<String> genres;
  final String status;
  final String? backdrop;
  final List<String> images;
  final String imageUrl;
  final String? imdbID;
  final String firstAirDate;
  final String title;
  final String titleOriginal;
  final String tmdbID;
  final double tmdbPopularity;
  final double tmdbVote;
  final int tmdbVoteCount;
  final List<Recommendation> recommendations;
  final List<Actor> actors;
  final ReviewSummary reviewSummary;
  final List<Streaming>? streaming;
  final List<ProductionAndCompany>? productionCompanies;
  final int totalEpisodes;
  final int totalSeasons;
  final List<TVDetailsNetwork>? networks;
  final List<TVDetailsSeason> seasons;

  @override
  TVWatchList? userList;
  @override
  ConsumeLater? consumeLater;

  TVDetails(
    this.id, this.description, this.genres, this.status,
    this.backdrop, this.images, this.imageUrl,
    this.imdbID, this.firstAirDate, this.title, this.titleOriginal,
    this.tmdbID, this.tmdbPopularity, this.tmdbVote, this.tmdbVoteCount,
    this.recommendations, this.actors, this.reviewSummary, this.streaming,
    this.productionCompanies, this.totalEpisodes, this.totalSeasons,
    this.networks, this.seasons, this.userList, this.consumeLater,
  );

  // val translations: List<Translation>?,
  // val trailers: List<Trailer>,
}