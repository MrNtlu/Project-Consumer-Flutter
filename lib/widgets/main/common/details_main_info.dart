import 'package:flutter/cupertino.dart';

class DetailsMainInfo extends StatelessWidget {
  final String vote;
  final String status;

  const DetailsMainInfo(
    this.vote,
    this.status,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  CupertinoIcons.star_fill,
                  color: CupertinoColors.systemYellow,
                  size: 16,
                ),
                const SizedBox(width: 3),
                Text(
                  vote,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Text(
              status,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.activeGreen,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}