import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';

class DiscoverAnimeProvider with ChangeNotifier {
  String? genre;
  String? demographics;
  String? themes;
  String sort = Constants.SortRequests[0].request;
  String? status;
  String? studios;
  String? decade;

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    demographics = null;
    themes = null;
    status = null;
    studios = null;
    decade = null;
  }

  void setDiscover({
    required String sort,
    String? genre,
    String? demographics,
    String? themes,
    String? status,
    String? studios,
    String? decade,
  }) {
    this.sort = sort;
    this.genre = genre;
    this.demographics = demographics;
    this.themes = themes;
    this.status = status;
    this.studios = studios;
    this.decade = decade;
  }
}
