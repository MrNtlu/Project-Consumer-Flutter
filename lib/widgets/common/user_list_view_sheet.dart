import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/providers/main/movie/movie_details_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/movie/movie_watch_list_sheet.dart';

class UserListViewSheet extends StatelessWidget {
  final MovieDetailsProvider provider;
  final String contentID;
  final String? externalID;
  final int? externalIntID;
  final ContentType contentType;

  final String title;
  final String message;
  final BaseUserList userList;

  const UserListViewSheet(
    this.provider, this.contentID, this.title, 
    this.message, this.userList, {
      this.externalID,
      this.externalIntID,
      required this.contentType, 
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(title),
      message: Text(
        message,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 16,
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

            switch (contentType) {
              case ContentType.movie:
                showCupertinoModalPopup(
                  context: context, 
                  builder: (context) {
                    return MovieWatchListSheet(provider, contentID, externalID!, userList: userList);
                  }
                );
                break;
              default:
                break;
            }
          },
          child: const Text('Change', style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () { //TODO Add are you sure dialog
            Navigator.pop(context);

            provider.deleteMovieWatchList(DeleteUserListBody(userList.id, contentType.request));
          },
          child: const Text('Remove'),
        ),
      ],
    );
  }
}
