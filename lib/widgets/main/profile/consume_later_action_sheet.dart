import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/consume_later_response.dart';
import 'package:watchlistfy/providers/main/profile/consume_later_provider.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';

class ConsumeLaterActionSheet extends StatelessWidget {
  final int index;
  final String id;
  final String title;
  final ContentType contentType;
  final ConsumeLaterProvider provider;
  final ConsumeLaterResponse content;
  final VoidCallback onMoveTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onViewTap;

  const ConsumeLaterActionSheet(
    this.index,
    this.id,
    this.title,
    this.contentType,
    this.provider,
    this.content,
    this.onMoveTap,
    this.onDeleteTap,
    this.onViewTap,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      message: Text(title),
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

            onMoveTap();
          },
          child: Text('Mark as ${contentType != ContentType.game ? 'Watched' : 'Played'}', style: const TextStyle(color: CupertinoColors.activeBlue)),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            showCupertinoDialog(
              context: context, 
              builder: (_) {
                return SureDialog("Do you want to remove it?", () {
                  Navigator.pop(context);

                  onDeleteTap();
                });
              }
            );
          },
          child: const Text('Remove'),
        ),
      ],
    );
  }
}