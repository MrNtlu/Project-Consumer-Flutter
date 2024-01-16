import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/constants.dart';

class ConsumeLaterSortFilterProvider with ChangeNotifier {
  String _sort = Constants.SortConsumeLaterRequests.first.request;

  String get sort => _sort;

  void setSort(String sort) {
    if (sort != _sort) {
      _sort = sort;
      notifyListeners(); 
    }
  }

  ContentType? _filterContent;

  ContentType? get filterContent => _filterContent;

  void setContentType(ContentType? contentType) {
    _filterContent = contentType;
    notifyListeners();
  }
}