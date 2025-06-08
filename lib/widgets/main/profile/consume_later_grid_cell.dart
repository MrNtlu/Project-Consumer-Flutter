import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class ConsumeLaterGridCell extends StatelessWidget {
  final String url;
  final String title;
  final VoidCallback onRemoveButton;
  final VoidCallback onMarkButton;

  const ConsumeLaterGridCell(
      this.url, this.title, this.onRemoveButton, this.onMarkButton,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            ContentCell(
              url.replaceFirst("original", "w400"),
              title,
              forceRatio: true,
              cacheHeight: 550,
              cacheWidth: 425,
            ),
            Positioned(
              top: -3,
              right: 0,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onMarkButton,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withValues(alpha: 0.9),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 32,
                        color: CupertinoColors.systemGreen,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onRemoveButton,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withValues(alpha: 0.9),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        CupertinoIcons.bookmark_fill,
                        size: 32,
                        color: AppColors().primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
