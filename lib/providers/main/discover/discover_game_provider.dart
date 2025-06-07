import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';

class DiscoverGameProvider with ChangeNotifier {
  String? genre;
  String sort = Constants.SortRequests[0].request;
  bool? tba;
  String? platform;
  String? publisher;
  int? rating;

  bool get isFiltering =>
      sort != Constants.SortRequests[0].request ||
      genre != null ||
      tba != null ||
      platform != null ||
      publisher != null ||
      rating != null;

  int get filteringCount {
    int count = 0;
    if (sort != Constants.SortRequests[0].request) count++;
    if (genre != null) count++;
    if (tba != null) count++;
    if (platform != null) count++;
    if (publisher != null) count++;
    if (rating != null) count++;
    return count;
  }

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    tba = null;
    platform = null;
    publisher = null;
    rating = null;
  }

  void setDiscover({
    required String sort,
    bool? tba,
    String? genre,
    String? platform,
    String? publisher,
    int? rating,
  }) {
    this.sort = sort;
    this.genre = genre;
    this.tba = tba;
    this.publisher = publisher;
    this.platform = platform;
    this.rating = rating;
  }
}
