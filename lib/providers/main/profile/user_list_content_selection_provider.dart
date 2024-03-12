import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/static/constants.dart';

class UserListContentSelectionProvider with ChangeNotifier {
  ContentType _selectedContent = ContentType.movie;

  ContentType get selectedContent => _selectedContent;

  void initContentType(ContentType contentType) {
    _selectedContent = contentType;
  }

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

  // Search
  bool _isSearching = false;

  bool get isSearching => _isSearching;

  List<UserListContent> searchList = [];

  void setSearching(bool isSearching) {
    if (isSearching != _isSearching) {
      _isSearching = isSearching;
      notifyListeners();
    }
  }

  void search(String search, List<UserListContent> source) {
    searchList = source.where(
      (content) =>
        content.title.toLowerCase().contains(search.toLowerCase()) ||
        content.titleOriginal.toLowerCase().contains(search.toLowerCase()) ||
        content.title.toLowerCase().startsWith(search.toLowerCase()) ||
        content.titleOriginal.toLowerCase().startsWith(search.toLowerCase())
    ).toList();
    notifyListeners();
  }
}
