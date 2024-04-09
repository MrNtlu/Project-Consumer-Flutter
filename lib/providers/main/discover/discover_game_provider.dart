import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';

class DiscoverGameProvider with ChangeNotifier {
  String? genre;
  String sort = Constants.SortRequests[0].request;
  bool? tba;
  String? platform;
  String? publisher;

  void reset() {
    sort = Constants.SortRequests[0].request;
    genre = null;
    tba = null;
    platform = null;
    publisher = null;
  }

  void setDiscover({
    required String sort,
    bool? tba,
    String? genre,
    String? platform,
    String? publisher,
  }) {
    this.sort = sort;
    this.genre = genre;
    this.tba = tba;
    this.publisher = publisher;
    this.platform = platform;
  }
}
