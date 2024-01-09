import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class ProfileExtraInfoText extends StatelessWidget {
  final String value;
  final String extraValue;
  final String label;

  const ProfileExtraInfoText(this.value, this.extraValue, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: CupertinoTheme.of(context).bgTextColor,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(width: 3),
            Text(
              extraValue,
              maxLines: 1,
              style: TextStyle(
                color: CupertinoTheme.of(context).bgTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: AppColors().primaryColor,
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}
