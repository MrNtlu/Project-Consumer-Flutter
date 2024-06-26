import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecommendationListShimmerCell extends StatelessWidget {
  const RecommendationListShimmerCell({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 125,
                width: 83,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const ColoredBox(color: CupertinoColors.systemGrey,)
                )
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
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
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
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
              Row(
                children: [
                  const Text(
                    "Recommended by ",
                    style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey2),
                  ),
                  const SizedBox(width: 6),
                  Row(
                    children: [
                      SizedBox(
                        height: 28,
                        width: 28,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const Icon(
                            Icons.person,
                            size: 28,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const SizedBox(
                          width: 25,
                          height: 20,
                          child: ColoredBox(color: CupertinoColors.systemGrey)
                        )
                      )
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
    );
  }
}