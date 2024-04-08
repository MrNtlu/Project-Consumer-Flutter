import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class CupertinoChip extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Function(bool)? onSelected;
  final EdgeInsets padding;
  final Widget? leading;
  final double size;

  const CupertinoChip({
    required this.isSelected, required this.onSelected,
    required this.label, this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
          color: isSelected ? AppColors().primaryColor : CupertinoTheme.of(context).onBgColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                color: isSelected ? CupertinoColors.white : CupertinoTheme.of(context).bgTextColor,
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
