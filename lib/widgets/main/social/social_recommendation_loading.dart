import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class SocialRecommendationLoading extends StatelessWidget {
  const SocialRecommendationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        20,
        (index) => Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey,
          highlightColor: CupertinoColors.systemGrey3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox(
                height: 200,
                child: ColoredBox(color: CupertinoColors.systemGrey)
              )
            ),
          ),
        )
      )
    );
  }
}