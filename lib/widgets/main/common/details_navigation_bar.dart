import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/pages/main/ai/ai_assistant_page.dart';
import 'package:watchlistfy/widgets/common/unauthorized_dialog.dart';

class DetailsNavigationBar extends StatelessWidget {
  final String title;
  final String contentType;
  final bool isAuthenticated;
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
    {required this.isAuthenticated, required this.onBookmarkTap, required this.onListTap, super.key}
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
            onPressed: () {
              HapticFeedback.lightImpact();

              if (isAuthenticated) {
                Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                  return AIAssistantPage(title, contentType);
                }));
              } else {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => const UnauthorizedDialog()
                );
              }
            },
            child: FaIcon(FontAwesomeIcons.robot, size: 18, color: CupertinoTheme.of(context).primaryColor),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              HapticFeedback.lightImpact();

              onListTap();
            },
            child: isUserListLoading
            ? const CupertinoActivityIndicator()
            : Icon(
              !isUserListNull
              ? CupertinoIcons.heart_fill
              : CupertinoIcons.heart
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              HapticFeedback.lightImpact();

              onBookmarkTap();
            },
            child: isBookmarkLoading
            ? const CupertinoActivityIndicator()
            : Icon(
              !isBookmarkNull
              ? CupertinoIcons.bookmark_fill
              : CupertinoIcons.bookmark
            ),
          ),
        ],
      )
      : null,
    );
  }
}