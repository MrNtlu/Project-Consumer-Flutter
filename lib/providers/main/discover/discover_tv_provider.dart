import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';

class DiscoverTVProvider with ChangeNotifier {
  String? genre;
  String sort = Constants.SortRequests[0].request;
  String? status;
  String? productionCompanies;
  String? numOfSeason;
  String? decade;
  String? country;
  int? rating;
  String? streaming;
  String streamingRegion = "";

  bool get isFiltering =>
      sort != Constants.SortRequests[0].request ||
      genre != null ||
      status != null ||
      productionCompanies != null ||
      numOfSeason != null ||
      decade != null ||
      country != null ||
      rating != null ||
      streaming != null;

  int get filteringCount {
    int count = 0;
    if (sort != Constants.SortRequests[0].request) count++;
    if (genre != null) count++;
    if (status != null) count++;
    if (productionCompanies != null) count++;
    if (numOfSeason != null) count++;
    if (decade != null) count++;
    if (country != null) count++;
    if (rating != null) count++;
    if (streaming != null) count++;
    return count;
  }

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    status = null;
    productionCompanies = null;
    numOfSeason = null;
    decade = null;
    country = null;
    rating = null;
    streaming = null;
  }

  void setDiscover({
    required String sort,
    String? genre,
    String? status,
    String? productionCompanies,
    String? numOfSeason,
    String? decade,
    String? country,
    int? rating,
    String? streaming,
    String streamingRegion = "",
  }) {
    this.sort = sort;
    this.genre = genre;
    this.status = status;
    this.productionCompanies = productionCompanies;
    this.numOfSeason = numOfSeason;
    this.decade = decade;
    this.country = country;
    this.rating = rating;
    this.streaming = streaming;
    this.streamingRegion = streamingRegion;
  }
}
