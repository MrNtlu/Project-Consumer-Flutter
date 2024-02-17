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

  void incrementContentType() {
    int newContentTypeIndex = ContentType.values.indexOf(_selectedContent) + 1;
    if (newContentTypeIndex >= ContentType.values.length) {
      newContentTypeIndex = 0;
    }

    _selectedContent = ContentType.values[newContentTypeIndex];
    notifyListeners();
  }

  void decrementContentType() {
    int newContentTypeIndex = ContentType.values.indexOf(_selectedContent) - 1;
    if (newContentTypeIndex < 0) {
      newContentTypeIndex = ContentType.values.length - 1;
    }

    _selectedContent = ContentType.values[newContentTypeIndex];
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
