import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class SocialLeaderboardLoading extends StatelessWidget {
  const SocialLeaderboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: List.generate(
        25,
        (index) => Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey,
          highlightColor: CupertinoColors.systemGrey3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox(
                width: double.infinity,
                height: 50,
                child: ColoredBox(color: CupertinoColors.systemGrey)
              )
            ),
          ),
        )
      )
    );
  }
}