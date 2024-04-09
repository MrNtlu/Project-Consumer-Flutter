import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';

class DiscoverMovieProvider with ChangeNotifier {
  String? genre;
  String sort = Constants.SortRequests[0].request;
  String? status;
  String? productionCompanies;
  String? decade;
  String? country;
  String? streaming;
  String streamingRegion = "";

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    status = null;
    productionCompanies = null;
    decade = null;
    country = null;
    streaming = null;
  }

  void setDiscover({
    required String sort,
    String? genre,
    String? status,
    String? productionCompanies,
    String? decade,
    String? country,
    String? streaming,
    String streamingRegion = "",
  }) {
    this.sort = sort;
    this.genre = genre;
    this.status = status;
    this.productionCompanies = productionCompanies;
    this.decade = decade;
    this.country = country;
    this.streaming = streaming;
    this.streamingRegion = streamingRegion;
  }
}
