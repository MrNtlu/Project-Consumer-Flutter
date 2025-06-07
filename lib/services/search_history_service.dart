import 'package:watchlistfy/static/shared_pref.dart';

class SearchHistoryService {
  static const String _searchHistoryKey = "search_history";
  static const int _maxHistoryItems = 20;

  static final SearchHistoryService _instance =
      SearchHistoryService._internal();
  factory SearchHistoryService() => _instance;
  SearchHistoryService._internal();

  /// Get search history list
  List<String> getSearchHistory() {
    final sharedPref = SharedPref().sharedPref;
    if (sharedPref == null) return [];

    final history = sharedPref.getStringList(_searchHistoryKey) ?? [];
    return history;
  }

  /// Add a search term to history
  void addSearchTerm(String searchTerm) {
    if (searchTerm.trim().isEmpty) return;

    final sharedPref = SharedPref().sharedPref;
    if (sharedPref == null) return;

    final normalizedTerm = searchTerm.trim();
    List<String> history = getSearchHistory();

    // Remove if already exists (to move to front)
    history.remove(normalizedTerm);

    // Add to front
    history.insert(0, normalizedTerm);

    // Keep only max items
    if (history.length > _maxHistoryItems) {
      history = history.take(_maxHistoryItems).toList();
    }

    sharedPref.setStringList(_searchHistoryKey, history);
  }

  /// Remove a specific search term
  void removeSearchTerm(String searchTerm) {
    final sharedPref = SharedPref().sharedPref;
    if (sharedPref == null) return;

    List<String> history = getSearchHistory();
    history.remove(searchTerm);
    sharedPref.setStringList(_searchHistoryKey, history);
  }

  /// Clear all search history
  void clearSearchHistory() {
    final sharedPref = SharedPref().sharedPref;
    if (sharedPref == null) return;

    sharedPref.remove(_searchHistoryKey);
  }

  /// Check if search history is empty
  bool get isHistoryEmpty => getSearchHistory().isEmpty;
}
