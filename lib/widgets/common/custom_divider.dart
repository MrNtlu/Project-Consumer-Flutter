import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class CustomDivider extends StatelessWidget {
  final double height;

  const CustomDivider({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: CupertinoTheme.of(context).bgTextColor,
      ),
    );
  }
}
