import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';

class UserListActionSheet extends StatelessWidget {
  final int index;
  final String id;
  final String title;
  final ContentType contentType;
  final UserListProvider provider;
  final VoidCallback onViewTap;

  const UserListActionSheet(this.index, this.id, this.title, this.contentType,
      this.provider, this.onViewTap,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      message: Text(title),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Close',
            style: TextStyle(color: CupertinoColors.systemBlue)),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);

            onViewTap();
          },
          child: const Text(
            'View',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: CupertinoColors.activeBlue)
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);

            switch (contentType) {
              case ContentType.movie:
                break;
              case ContentType.tv:
                break;
              case ContentType.anime:
                break;
              case ContentType.game:
                break;
              default:
                break;
            }
          },
          child: const Text('Edit',
              style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            //TODO Add are you sure dialog
            Navigator.pop(context);
            provider.deleteUserList(
                index, DeleteUserListBody(id, contentType.request));
          },
          child: const Text('Remove'),
        ),
      ],
    );
  }
}
