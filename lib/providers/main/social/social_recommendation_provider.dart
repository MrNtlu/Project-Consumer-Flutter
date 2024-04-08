import 'package:flutter/cupertino.dart';

class SocialRecommendationProvider with ChangeNotifier {
  bool isLoading = false;

  void setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}
