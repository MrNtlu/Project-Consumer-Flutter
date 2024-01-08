import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';

class DiscoverMovieProvider with ChangeNotifier {
  String? genre;
  String sort = Constants.SortRequests[0].request;
  String? status;
  String? productionCompanies;
  String? decade;

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    status = null;
    productionCompanies = null;
    decade = null;
  }

  void setDiscover({
    required String sort,
    String? genre,
    String? status,
    String? productionCompanies,
    String? decade,
  }) {
    this.sort = sort;
    this.genre = genre;
    this.status = status;
    this.productionCompanies = productionCompanies;
    this.decade = decade;
  }
}
