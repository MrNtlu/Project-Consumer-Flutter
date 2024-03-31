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
    if (_filterContent != contentType) {
      _filterContent = contentType;
      notifyListeners();
    }
  }

  String? _genre;

  String? get genre => _genre;

  void setGenre(String? genre) {
    if (_genre != genre) {
      _genre = genre;
      notifyListeners();
    }
  }

  String? _streaming;

  String? get streaming => _streaming;

  void setStreamingPlatform(String? streaming) {
    if (_streaming != streaming) {
      _streaming = streaming;
      notifyListeners();
    }
  }
}
