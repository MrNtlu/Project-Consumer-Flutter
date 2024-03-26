import 'package:flutter/cupertino.dart';

class SeeAllTitle extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool shouldHideSeeAllButton;

  const SeeAllTitle(this.title, this.onTap, {this.shouldHideSeeAllButton = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
          if (!shouldHideSeeAllButton)
          CupertinoButton(
            minSize: 0,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            onPressed: () {
              onTap();
            },
            child: const Icon(CupertinoIcons.chevron_right)
          )
        ],
      ),
    );
  }
}
