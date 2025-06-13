import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/widgets/main/common/details_avatar_button.dart';

class DetailsButtonRow extends StatelessWidget {
  final VoidCallback onRecommendationsPressed;

  const DetailsButtonRow(
    this.onRecommendationsPressed, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cupertinoTheme.barBackgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cupertinoTheme.primaryColor.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: DetailsAvatarButton(
        "Recommendations",
        FontAwesomeIcons.solidLightbulb,
        CupertinoColors.systemYellow,
        () {
          HapticFeedback.lightImpact();
          onRecommendationsPressed();
        },
      ),
    );
  }
}
