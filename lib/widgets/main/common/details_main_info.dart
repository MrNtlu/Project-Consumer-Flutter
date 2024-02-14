import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';

class DetailsMainInfo extends StatelessWidget {
  final String vote;
  final String status;
  final String contentType;
  final String id;

  const DetailsMainInfo(this.vote, this.status, this.contentType, this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  CupertinoIcons.star_fill,
                  color: CupertinoColors.systemYellow,
                  size: 16,
                ),
                const SizedBox(width: 3),
                Text(
                  vote,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Text(
              status,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.activeGreen,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const SizedBox(height: 12,),
        Align(
          alignment: Alignment.centerRight,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            minSize: 0,
            child: const Icon(CupertinoIcons.share),
            onPressed: () async {
              final url = '${Constants.BASE_DOMAIN_URL}/$contentType/$id';
              try {
                final box = context.findRenderObject() as RenderBox?;
          
                if (box != null) {
                  Share.share(
                    url,
                    subject: 'Share ${ContentType.values.where((element) => contentType == element.request).first.value}', 
                    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                  ); 
                }
              } catch (_) {
                await Clipboard.setData(ClipboardData(text: url));
                if (context.mounted) {
                  showCupertinoDialog(context: context, builder: (_) => const MessageDialog("Copied to clipboard."));
                }
              }
            }
          ),
        ),
      ],
    );
  }
}