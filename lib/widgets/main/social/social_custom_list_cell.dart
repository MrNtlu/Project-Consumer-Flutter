import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_share_details_page.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/main/common/author_info_row.dart';

class SocialCustomListCell extends StatelessWidget {
  final CustomList data;

  const SocialCustomListCell(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortedContent = data.content.sorted((a, b) => a.order.compareTo(b.order));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (_) {
              return CustomListShareDetailsPage(data.id);
            })
          );
        },
        child: Container(
          decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoTheme.of(context).brightness == Brightness.dark ? const Color(0xFF212121) : CupertinoColors.systemGrey3,
            width: 1.75,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      data.name,
                      minFontSize: 14,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ),
                  Text(
                    DateTime.parse(data.createdAt).dateToHumanDate(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 75,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: sortedContent.length,
                        itemBuilder: (context, index) {
                          final listContent = sortedContent[index];
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ContentCell(listContent.imageURL ?? '', listContent.titleEn, cornerRadius: 8, forceRatio: true),
                          );
                        }
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(CupertinoIcons.chevron_right)
                ],
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Icon(data.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart, size: 20),
                  ),
                  Text(data.popularity.toString()),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    child: Icon(data.isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark, size: 20),
                  ),
                  Text(data.bookmarkCount.toString()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AuthorInfoRow(data.author, size: 24)
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}