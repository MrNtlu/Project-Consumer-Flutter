import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';

class CustomListCreateProvider with ChangeNotifier {
  int reasonTextCount = 0;

  void updateTextCount(int newCount) {
    reasonTextCount = newCount;
    notifyListeners();
  }

  List<CustomListContent> selectedContent = [];

  void addNewContent(CustomListContent content) {
    selectedContent.add(content);
    notifyListeners();
  }

  void removeContent(String contentID) {
    selectedContent.removeWhere((element) => element.contentID == contentID);
    notifyListeners();
  }

  void reOrder(int newIndex, int oldIndex) {
    if(newIndex > oldIndex){
      newIndex -= 1;
    }

    final items = selectedContent.removeAt(oldIndex);
    selectedContent.insert(newIndex, items);
    notifyListeners();
  }

  bool doesContain(String contentID) {
    return selectedContent.where((element) => element.contentID == contentID).isNotEmpty;
  }
}
