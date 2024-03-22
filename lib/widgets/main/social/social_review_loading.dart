import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class SocialReviewLoading extends StatelessWidget {
  const SocialReviewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        20,
        (index) => Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey,
          highlightColor: CupertinoColors.systemGrey3,
          child: Padding(
            padding: index == 0 ? const EdgeInsets.only(left: 8, right: 4) : const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox(
                height: 200,
                width: 300,
                child: ColoredBox(color: CupertinoColors.systemGrey)
              )
            ),
          ),
        )
      )
    );
  }
}