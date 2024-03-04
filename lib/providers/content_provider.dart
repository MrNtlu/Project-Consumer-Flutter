import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';

class ContentProvider with ChangeNotifier {
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
}
