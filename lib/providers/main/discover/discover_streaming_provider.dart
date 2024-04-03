import 'package:flutter/cupertino.dart';

class StreamingPlatformStateProvider with ChangeNotifier {
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  void toggleState() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}