import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';

class CustomListCreateProvider with ChangeNotifier {
  final List<CustomListContent> selectedContent = [];

  void addNewContent(CustomListContent content) {
    selectedContent.add(content);
    notifyListeners();
  }

  void removeContent(String contentID) {
    selectedContent.removeWhere((element) => element.contentID == contentID);
    notifyListeners();
  }

  bool doesContain(String contentID) {
    return selectedContent.where((element) => element.contentID == contentID).isNotEmpty;
  }
}
