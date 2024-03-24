import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';
import 'package:watchlistfy/widgets/main/common/recommendation_button.dart';

class DetailsRecommendationsTitle extends StatelessWidget {
  final bool isRecommendationEmpty;
  final VoidCallback onTap;

  const DetailsRecommendationsTitle(
    this.onTap,
    {
    this.isRecommendationEmpty = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: DetailsTitle("Recommendations")),
          if (!isRecommendationEmpty)
          RecommendationButton(onTap)
        ],
      ),
    );
  }
}