import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';

class SearchHistoryList extends StatelessWidget {
  final List<String> searchHistory;
  final Function(String) onHistoryItemTap;
  final Function(String) onDeleteHistoryItem;
  final VoidCallback? onClearAllHistory;

  const SearchHistoryList({
    super.key,
    required this.searchHistory,
    required this.onHistoryItemTap,
    required this.onDeleteHistoryItem,
    this.onClearAllHistory,
  });

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final mediaQuery = MediaQuery.of(context);

    if (searchHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                "assets/lottie/search.json",
                height: mediaQuery.size.height * 0.3,
                frameRate: FrameRate(
                  RefreshRateHelper().getRefreshRate(),
                ),
              ),
              const Text(
                "No search history yet.",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your search history will appear here.",
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header with clear all button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Searches",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onClearAllHistory != null)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onClearAllHistory,
                  child: const Text(
                    "Clear All",
                    style: TextStyle(
                      color: CupertinoColors.systemRed,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // History items
        Expanded(
          child: ListView.builder(
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              final historyItem = searchHistory[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(
                  color: cupertinoTheme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CupertinoListTile(
                  leading: const Icon(
                    CupertinoIcons.clock,
                    color: CupertinoColors.systemGrey,
                    size: 20,
                  ),
                  title: Text(
                    historyItem,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => onDeleteHistoryItem(historyItem),
                    child: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: CupertinoColors.systemGrey3,
                      size: 20,
                    ),
                  ),
                  onTap: () => onHistoryItemTap(historyItem),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
