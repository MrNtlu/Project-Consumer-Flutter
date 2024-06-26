import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/constants.dart';

class UserListShimmerCell extends StatelessWidget {
  final String title;
  final ContentType selectedContent;
  final int? totalSeasons;
  final int? totalEpisodes;

  const UserListShimmerCell(
    this.title,
    this.selectedContent,
    this.totalSeasons,
    this.totalEpisodes,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);

    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey,
      highlightColor: CupertinoColors.systemGrey3,
      child: globalProvider.userListMode == Constants.UserListUIModes.first
      ? Padding(
        padding: const EdgeInsets.only(left: 3, right: 6),
        child: Row(
          children: [
            SizedBox(
              height: 125,
              width: 83.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const ColoredBox(color: CupertinoColors.systemGrey)
              )
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
                        if(selectedContent != ContentType.movie && selectedContent != ContentType.game)
                        Text("/${totalEpisodes ?? "?"} eps"),
                        if (selectedContent == ContentType.game)
                        const Text(' hrs')
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
      : Padding(
        padding: const EdgeInsets.only(right: 3),
        child: Row(
          children: [
            const SizedBox(
              width: 2,
              height: 75,
              child: ColoredBox(color: CupertinoColors.systemGrey),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 75,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const ColoredBox(color: CupertinoColors.systemGrey)
              )
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
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          minSize: 0,
                          child: const Icon(CupertinoIcons.ellipsis_vertical, size: 18),
                          onPressed: () {}
                        )
                      ],
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
                        if(selectedContent != ContentType.movie && selectedContent != ContentType.game)
                        Text("/${totalEpisodes ?? "?"} eps"),
                        if (selectedContent == ContentType.game)
                        const Text(' hrs')
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}