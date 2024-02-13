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
            padding: const EdgeInsets.only(right: 8),
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