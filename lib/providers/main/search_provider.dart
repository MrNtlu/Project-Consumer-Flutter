import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/search_history_service.dart';

class SearchProvider with ChangeNotifier {
  String search = "";
  bool _isShowingHistory = false;
  List<String> _searchHistory = [];
  final SearchHistoryService _historyService = SearchHistoryService();

  bool get isShowingHistory => _isShowingHistory;
  List<String> get searchHistory => _searchHistory;

  SearchProvider() {
    _loadSearchHistory();
  }

  void _loadSearchHistory() {
    _searchHistory = _historyService.getSearchHistory();
    notifyListeners();
  }

  void setSearch(String search) {
    this.search = search;
    _isShowingHistory = false;

    // Add to history if not empty and actually searching
    if (search.trim().isNotEmpty) {
      _historyService.addSearchTerm(search.trim());
      _loadSearchHistory();
    }

    notifyListeners();
  }

  void showSearchHistory() {
    _isShowingHistory = true;
    _loadSearchHistory();
    notifyListeners();
  }

  void hideSearchHistory() {
    _isShowingHistory = false;
    notifyListeners();
  }

  void removeSearchHistoryItem(String item) {
    _historyService.removeSearchTerm(item);
    _loadSearchHistory();
  }

  void clearSearchHistory() {
    _historyService.clearSearchHistory();
    _loadSearchHistory();
  }

  void selectFromHistory(String historyItem) {
    search = historyItem;
    _isShowingHistory = false;
    notifyListeners();
  }

  bool get hasSearchHistory => _searchHistory.isNotEmpty;
}
