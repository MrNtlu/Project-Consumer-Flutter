import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  late String search;

  void setSearch(String search) {
    this.search = search;
  }
}
