import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class ReviewWithContentShimmerCell extends StatelessWidget {
  const ReviewWithContentShimmerCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey,
      highlightColor: CupertinoColors.systemGrey3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoTheme.of(context).brightness == Brightness.dark ? const Color(0xFF212121) : CupertinoColors.systemGrey3,
            width: 1.75,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50,
                  width: 35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const ColoredBox(color: CupertinoColors.systemGrey,)
                  )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const SizedBox(
                          width: 150,
                          height: 35,
                          child: ColoredBox(color: CupertinoColors.systemGrey)
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const SizedBox(
                    width: 15,
                    height: 25,
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
            const SizedBox(height: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const SizedBox(
                  width: double.infinity,
                  child: ColoredBox(color: CupertinoColors.systemGrey)
                )
              )
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  child: Icon(CupertinoIcons.heart_fill, size: 20),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const SizedBox(
                    width: 50,
                    height: 25,
                    child: ColoredBox(color: CupertinoColors.systemGrey)
                  )
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}