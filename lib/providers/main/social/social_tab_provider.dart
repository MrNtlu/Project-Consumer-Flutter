import 'package:flutter/cupertino.dart';

class SocialTabProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setNewIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }
}