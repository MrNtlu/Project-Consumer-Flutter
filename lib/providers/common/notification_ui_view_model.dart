import 'package:flutter/cupertino.dart';

class NotificationUIViewModel extends ChangeNotifier {
  String? title;
  String? description;

  bool shouldShowNotification() => title != null && description != null;

  void setNotification(String title, String description) {
    this.title = title;
    this.description = description;
    notifyListeners();
  }

  void clearNotification() {
    title = null;
    description = null;
    notifyListeners();
  }
}
