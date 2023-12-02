import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';

class ContentProvider with ChangeNotifier {
  ContentType _selectedContent = ContentType.movie;

  ContentType get selectedContent =>_selectedContent;

  void setContentType(ContentType contentType) {
    _selectedContent = contentType;
    notifyListeners();
  }
}
