import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class CupertinoChip extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Function(bool) onSelected;

  const CupertinoChip({required this.isSelected, required this.onSelected, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onSelected(isSelected);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected ? AppColors().primaryColor : CupertinoTheme.of(context).onBgColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: isSelected ? CupertinoColors.white : CupertinoTheme.of(context).bgTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
