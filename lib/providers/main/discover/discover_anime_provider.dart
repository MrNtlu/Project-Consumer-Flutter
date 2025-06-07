import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';

class DiscoverAnimeProvider with ChangeNotifier {
  String? genre;
  String? demographics;
  String? themes;
  String sort = Constants.SortRequests[0].request;
  String? status;
  String? studios;
  String? season;
  int? year;
  String? streaming;
  int? rating;

  bool get isFiltering =>
      sort != Constants.SortRequests[0].request ||
      genre != null ||
      demographics != null ||
      themes != null ||
      status != null ||
      studios != null ||
      season != null ||
      year != null ||
      rating != null ||
      streaming != null;

  int get filteringCount {
    int count = 0;
    if (sort != Constants.SortRequests[0].request) count++;
    if (genre != null) count++;
    if (demographics != null) count++;
    if (themes != null) count++;
    if (status != null) count++;
    if (studios != null) count++;
    if (season != null) count++;
    if (year != null) count++;
    if (rating != null) count++;
    if (streaming != null) count++;
    return count;
  }

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    demographics = null;
    themes = null;
    status = null;
    studios = null;
    season = null;
    year = null;
    rating = null;
    streaming = null;
  }

  void setDiscover({
    required String sort,
    String? genre,
    String? demographics,
    String? themes,
    String? status,
    String? studios,
    String? season,
    int? year,
    int? rating,
    String? streaming,
  }) {
    this.sort = sort;
    this.genre = genre;
    this.demographics = demographics;
    this.themes = themes;
    this.status = status;
    this.season = season;
    this.year = year;
    this.studios = studios;
    this.rating = rating;
    this.streaming = streaming;
  }
}
