import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_create_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_details_page.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';

class CustomListActionSheet extends StatelessWidget {
  final CustomList content;
  final Future<BaseMessageResponse> Function(String, CustomList) deleteCustomList;
  final VoidCallback _fetchData;

  const CustomListActionSheet(
    this.content,
    this.deleteCustomList,
    this._fetchData,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Close', style: TextStyle(color: CupertinoColors.systemBlue)),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);

            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return CustomListDetailsPage(content, deleteCustomList);
              })
            );
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

            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return CustomListCreatePage(_fetchData, customList: content);
              })
            );
          },
          child: const Text('Edit', style: TextStyle(color: CupertinoColors.activeBlue)),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            showCupertinoDialog(
              context: context, 
              builder: (_) {
                return SureDialog("Do you want to delete it?", () {
                  Navigator.pop(context);

                  showCupertinoDialog(
                    context: context,
                    builder: (_) {
                      return const LoadingDialog();
                    }
                  );

                  deleteCustomList(
                    content.id,
                    content
                  ).then((value) {
                    Navigator.pop(context);

                    showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        if (value.error != null) {
                          return ErrorDialog(value.error!);
                        } else {
                          return MessageDialog(value.message ?? "Successfully deleted.");
                        }
                      }
                    );
                  });
                });
              }
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}