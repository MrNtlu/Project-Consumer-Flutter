import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class SheetDragLine extends StatelessWidget {
  const SheetDragLine({super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: cupertinoTheme.bgTextColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
