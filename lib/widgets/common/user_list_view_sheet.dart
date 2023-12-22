import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/user_list_add_sheet.dart';

class UserListViewSheet extends StatelessWidget {
  final String title;
  final String message;

  const UserListViewSheet(this.title, this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(title),
      message: Text(
        message,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: CupertinoTheme.of(context).bgTextColor,
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Close', style: TextStyle(color: CupertinoColors.systemBlue)),
      ),
      actions: [
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            showCupertinoModalPopup(
              context: context, 
              builder: (context) {
                return UserListAddSheet();
              }
            );
          },
          child: const Text('Change', style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Remove'),
        ),
      ],
    );
  }
}
