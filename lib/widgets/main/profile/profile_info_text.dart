import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class ProfileInfoText extends StatelessWidget {
  final String value;
  final String label;

  const ProfileInfoText(this.value, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final size = (mediaQuery.size.width * 0.85) / 4;

    return SizedBox(
      width: size,
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            style: TextStyle(
              color: cupertinoTheme.bgTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: AppColors().primaryColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
