import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';

class RecommendationButton extends StatelessWidget {
  final VoidCallback onTap;
  const RecommendationButton(this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      minSize: 0,
      onPressed: onTap,
      child: const AutoSizeText(
        "💡 User Recommendations",
        minFontSize: 12,
        style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w500)
      ),
    );
  }
}