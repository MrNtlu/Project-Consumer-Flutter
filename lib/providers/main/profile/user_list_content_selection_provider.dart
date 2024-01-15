import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/constants.dart';

class UserListContentSelectionProvider with ChangeNotifier {
  ContentType _selectedContent = ContentType.movie;

  ContentType get selectedContent => _selectedContent;

  void setContentType(ContentType contentType) {
    _selectedContent = contentType;
    notifyListeners();
  }

  String _sort = Constants.SortUserListRequests[0].request;

  String get sort => _sort;

  void setSort(String sort) {
    if (sort != _sort) {
      _sort = sort;
      notifyListeners(); 
    }
  }
}
