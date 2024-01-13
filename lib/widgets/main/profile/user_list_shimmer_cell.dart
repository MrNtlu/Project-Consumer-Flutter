import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class UserListShimmerCell extends StatelessWidget {
  final String imageUrl;
  final String title;
  final ContentType selectedContent;
  final int? totalSeasons;
  final int? totalEpisodes;

  const UserListShimmerCell(
    this.imageUrl,
    this.title,
    this.selectedContent,
    this.totalSeasons,
    this.totalEpisodes,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey, 
      highlightColor: CupertinoColors.systemGrey3,
      child: Row(
        children: [
          const SizedBox(
            width: 3,
            height: 125,
            child: ColoredBox(color: CupertinoColors.systemGrey),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 125,
            child: ContentCell(imageUrl, title)
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          title,
                          minFontSize: 14,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          wrapWords: true,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.ellipsis_vertical),
                        onPressed: () {}
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 1,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow, size: 14),
                      SizedBox(width: 3),
                      Text(
                        "?", style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "???", style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if(selectedContent == ContentType.tv)
                      const Text(
                        "?", style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if(selectedContent == ContentType.tv)
                      Text("/${totalSeasons ?? "?"} seas"),
                      const Spacer(),
                      if(selectedContent != ContentType.movie)
                      const Text(
                        "?", style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if(selectedContent != ContentType.movie)
                      Text("/${totalEpisodes ?? "?"} eps"),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}