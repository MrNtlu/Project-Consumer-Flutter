import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class CustomListShimmerCell extends StatelessWidget {
  const CustomListShimmerCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey, 
      highlightColor: CupertinoColors.systemGrey3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.systemGrey,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 150,
                        height: 25,
                        child: ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    )
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const ColoredBox(color: CupertinoColors.systemGrey)
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(CupertinoIcons.chevron_right)
                ],
              ),
              const Spacer(),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: Icon(CupertinoIcons.heart_fill, size: 20),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 25,
                        height: 25,
                        child: ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                      child: Icon(CupertinoIcons.bookmark_fill, size: 20),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 25,
                        height: 25,
                        child: ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    ),
                    const Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: const SizedBox(
                        width: 25,
                        height: 25,
                        child: ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    ),
                    const SizedBox(width: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const SizedBox(
                        width: 50,
                        height: 25,
                        child: ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}