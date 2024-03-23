import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

class DetailsRecommendationsTitle extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DetailsRecommendationsTitle(
    this.onTap, {
    this.title = "Recommendations",
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
          Expanded(child: DetailsTitle(title)),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            minSize: 0,
            onPressed: onTap,
            child: const AutoSizeText(
              "💡 User Recommendations",
              minFontSize: 12,
              style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w500)
            ),
          )
        ],
      ),
    );
  }
}