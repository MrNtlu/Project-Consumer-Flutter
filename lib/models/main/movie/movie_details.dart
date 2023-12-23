import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/actor.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/production_company.dart';
import 'package:watchlistfy/models/main/common/recommendation.dart';
import 'package:watchlistfy/models/main/common/review_summary.dart';
import 'package:watchlistfy/models/main/common/streaming.dart';

class MovieDetails extends DetailsModel {
  final String id;
  final String description;
  final List<String> genres;
  final int length;
  final String status;
  final String? backdrop;
  final List<String> images;
  final String imageUrl;
  final String? imdbID;
  final String releaseDate;
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

  @override
  BaseUserList? userList;
  @override
  ConsumeLater? consumeLater;

  MovieDetails(
    this.id, this.description, this.genres, this.length,
    this.status, this.backdrop, this.images, this.imageUrl,
    this.imdbID, this.releaseDate, this.title, this.titleOriginal,
    this.tmdbID, this.tmdbPopularity, this.tmdbVote, this.tmdbVoteCount,
    this.recommendations, this.actors, this.reviewSummary, this.streaming,
    this.productionCompanies, this.userList, this.consumeLater,
  );

    //TODO List implementation https://github.com/MrNtlu/Asset-Manager-Flutter/blob/0699c81d620d1d96d04073c6cfbc3afe6202b8bb/lib/common/models/response.dart#L374
    // val translations: List<Translation>?,
    // val trailers: List<Trailer>,
}