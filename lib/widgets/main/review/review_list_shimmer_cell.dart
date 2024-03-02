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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 150,
                        height: 20,
                        child: ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    ),
                    const SizedBox(height: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 100,
                        height: 15,
                        child: ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    )
                  ],
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const SizedBox(
                    width: 25,
                    height: 20,
                    child: ColoredBox(color: CupertinoColors.systemGrey)
                  )
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox(
                height: 25,
                width: double.infinity,
                child: ColoredBox(color: CupertinoColors.systemGrey)
              )
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const SizedBox(
                    width: 25,
                    height: 20,
                    child: ColoredBox(color: CupertinoColors.systemGrey)
                  )
                ),
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