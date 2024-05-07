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

  const CupertinoChip({
    required this.isSelected, required this.onSelected,
    required this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    this.cornerRadius = 8,
    this.selectedBGColor = const Color(0xFF2196F3), // Primary Color
    this.selectedTextColor = CupertinoColors.white,
    this.size = 14,
    this.leading, super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          color: isSelected ? selectedBGColor : CupertinoTheme.of(context).onBgColor,
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null)
            leading!,
            if (leading != null)
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedTextColor : CupertinoTheme.of(context).bgTextColor,
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
