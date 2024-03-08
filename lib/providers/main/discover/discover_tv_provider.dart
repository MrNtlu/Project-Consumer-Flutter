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

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    status = null;
    productionCompanies = null;
    numOfSeason = null;
    decade = null;
    country = null;
  }

  void setDiscover({
    required String sort,
    String? genre,
    String? status,
    String? productionCompanies,
    String? numOfSeason,
    String? decade,
    String? country,
  }) {
    this.sort = sort;
    this.genre = genre;
    this.status = status;
    this.productionCompanies = productionCompanies;
    this.numOfSeason = numOfSeason;
    this.decade = decade;
    this.country = country;
  }
}
