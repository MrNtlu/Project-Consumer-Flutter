import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReviewListShimmerCell extends StatelessWidget {
  const ReviewListShimmerCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey, 
      highlightColor: CupertinoColors.systemGrey3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "        ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "XX XXX XX",
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.systemGrey2
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  "X",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(width: 3),
                const Icon(
                  CupertinoIcons.star_fill,
                  color: CupertinoColors.systemYellow,
                  size: 15,
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "          ",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CupertinoButton(
                  onPressed: () {},
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: const Icon(CupertinoIcons.heart, size: 20),
                ),
                const Text("X"),
                const Spacer(),
                CupertinoButton(
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  onPressed: () {},
                  child: const Text("Read More"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}