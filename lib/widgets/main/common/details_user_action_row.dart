import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:watchlistfy/widgets/common/notification_overlay.dart';

class DetailsUserActionRow extends StatelessWidget {
  final bool isAuthenticated;
  final bool isUserListNull;
  final bool isBookmarkNull;
  final bool isUserListLoading;
  final bool isBookmarkLoading;
  final VoidCallback onListTap;
  final VoidCallback onBookmarkTap;

  const DetailsUserActionRow({
    required this.isAuthenticated,
    required this.isUserListNull,
    required this.isBookmarkNull,
    required this.isUserListLoading,
    required this.isBookmarkLoading,
    required this.onListTap,
    required this.onBookmarkTap,
    super.key,
  });

  void _handleListTap(BuildContext context) {
    if (!isUserListLoading) {
      if (isAuthenticated) {
        HapticFeedback.lightImpact();
        onListTap();
      } else {
        NotificationOverlay().show(
          context,
          title: "Authentication Required",
          message: "Please sign in to add items to your list.",
          isError: true,
        );
      }
    }
  }

  void _handleBookmarkTap(BuildContext context) {
    if (!isBookmarkLoading) {
      if (isAuthenticated) {
        HapticFeedback.lightImpact();
        onBookmarkTap();
      } else {
        NotificationOverlay().show(
          context,
          title: "Authentication Required",
          message: "Please sign in to bookmark items.",
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Add to List Button (Full Width)
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _handleListTap(context),
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isUserListNull
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.activeGreen,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isUserListNull
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.activeGreen)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isUserListLoading
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isUserListNull
                                ? CupertinoIcons.plus
                                : CupertinoIcons.checkmark_alt,
                            color: CupertinoColors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isUserListNull ? "Add to List" : "In List",
                            style: const TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Bookmark Button (Icon)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _handleBookmarkTap(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      cupertinoTheme.barBackgroundColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isBookmarkNull
                        ? cupertinoTheme.primaryColor.withValues(alpha: 0.2)
                        : CupertinoColors.systemYellow.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: isBookmarkLoading
                    ? const CupertinoActivityIndicator()
                    : Icon(
                        isBookmarkNull
                            ? CupertinoIcons.bookmark
                            : CupertinoIcons.bookmark_fill,
                        color: isBookmarkNull
                            ? cupertinoTheme.primaryColor
                            : CupertinoColors.systemYellow,
                        size: 22,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
