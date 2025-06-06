import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

class CustomListEntryCell extends StatelessWidget {
  final int? index;
  final ContentType? selectedContent;
  final BaseContent content;
  final bool doesContain;
  final String? contentType;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;
  final bool isRecommendation;

  const CustomListEntryCell(this.selectedContent, this.content,
      this.doesContain, this.onRemove, this.onAdd,
      {this.index, this.contentType, this.isRecommendation = false, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: selectedContent != null
            ? () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (_) {
                      final contentType = ContentType.values
                          .where((element) =>
                              element.request == selectedContent!.request)
                          .first;
                      return DetailsPage(
                        id: content.id,
                        contentType: contentType,
                      );
                    },
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 3, top: 4, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onAdd == null && onRemove != null)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.reorder_rounded),
                ),
              if (index != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text("${index!}.",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              SizedBox(
                height: onAdd != null ? 150 : 125,
                child: ContentCell(
                  content.imageUrl,
                  content.titleEn,
                  forceRatio: true,
                  cacheHeight: onAdd != null ? 400 : 325,
                  cacheWidth:
                      contentType == "Game" ? 450 : (onAdd != null ? 270 : 225),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.titleEn,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        content.titleOriginal,
                        style:
                            const TextStyle(color: CupertinoColors.systemGrey2),
                      ),
                    ],
                  ),
                ),
              ),
              if (contentType != null)
                CupertinoChip(
                  isSelected: true,
                  onSelected: (value) {},
                  label: contentType!,
                ),
              if (onRemove != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isRecommendation)
                      CupertinoButton(
                        padding: const EdgeInsets.all(3),
                        onPressed: doesContain
                            ? () {
                                onRemove!();
                              }
                            : () {},
                        child: Icon(Icons.remove_circle,
                            color: doesContain
                                ? CupertinoColors.destructiveRed
                                : CupertinoColors.systemGrey2),
                      ),
                    if (onAdd != null)
                      CupertinoButton(
                        padding: const EdgeInsets.all(3),
                        onPressed: doesContain
                            ? () {}
                            : () {
                                if (isRecommendation) {
                                  Navigator.pop(context);
                                }
                                onAdd!();
                              },
                        child: Icon(Icons.add_circle,
                            color: doesContain
                                ? CupertinoColors.systemGrey2
                                : CupertinoColors.activeGreen),
                      ),
                  ],
                )
            ],
          ),
        ));
  }
}
