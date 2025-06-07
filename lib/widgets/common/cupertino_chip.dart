import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class CupertinoChip extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Function(bool)? onSelected;
  final EdgeInsets padding;
  final Widget? leading;
  final double size;
  final double cornerRadius;
  final Color selectedBGColor;
  final Color selectedTextColor;
  final bool shouldShowBorder;

  const CupertinoChip({
    required this.isSelected,
    required this.onSelected,
    required this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.cornerRadius = 8,
    this.selectedBGColor = const Color(0xFF2196F3), // Primary Color
    this.selectedTextColor = CupertinoColors.white,
    this.size = 14,
    this.leading,
    this.shouldShowBorder = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelected != null
          ? () {
              onSelected!(isSelected);
            }
          : null,
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected ? selectedBGColor : cupertinoTheme.onBgColor,
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
          border: shouldShowBorder
              ? Border.all(
                  color: cupertinoTheme.bgTextColor.withValues(alpha: 0.1),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) leading!,
            if (leading != null) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? selectedTextColor : cupertinoTheme.bgTextColor,
                fontSize: size,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
