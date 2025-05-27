import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  String search = "";

  void setSearch(String search) {
    this.search = search;
  }
}
