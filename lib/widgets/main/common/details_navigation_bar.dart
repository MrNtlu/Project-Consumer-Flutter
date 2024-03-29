import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DetailsNavigationBar extends StatelessWidget {
  final String title;
  final String contentType;
  final VoidCallback onBookmarkTap;
  final VoidCallback onListTap;

  final bool isItemNull;
  final bool isUserListNull;
  final bool isBookmarkNull;
  final bool isUserListLoading;
  final bool isBookmarkLoading;

  const DetailsNavigationBar(
    this.title, this.contentType, this.isItemNull, this.isUserListNull,
    this.isBookmarkNull, this.isUserListLoading, this.isBookmarkLoading,
    {required this.onBookmarkTap, required this.onListTap, super.key}
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      largeTitle: AutoSizeText(
        title,
        style: const TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: !isItemNull
      ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: isUserListLoading
            ? null
            : () {
              HapticFeedback.lightImpact();

              onListTap();
            },
            child: isUserListLoading
            ? const CupertinoActivityIndicator()
            : Icon(
              !isUserListNull
              ? CupertinoIcons.heart_fill
              : CupertinoIcons.heart,
              size: 25,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: isBookmarkLoading
            ? null
            : () {
              HapticFeedback.lightImpact();

              onBookmarkTap();
            },
            child: isBookmarkLoading
            ? const CupertinoActivityIndicator()
            : Icon(
              !isBookmarkNull
              ? CupertinoIcons.bookmark_fill
              : CupertinoIcons.bookmark,
              size: 25,
            ),
          ),
        ],
      )
      : null,
    );
  }
}