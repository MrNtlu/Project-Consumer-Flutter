import 'package:flutter/cupertino.dart';

class DetailsMainInfo extends StatelessWidget {
  final String vote;
  final String status;

  const DetailsMainInfo(
    this.vote,
    this.status, {
    super.key,
  });

  Color _getStatusColor() {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('released') ||
        statusLower.contains('ended') ||
        statusLower.contains('finished')) {
      return CupertinoColors.activeGreen;
    } else if (statusLower.contains('upcoming') ||
        statusLower.contains('planned') ||
        statusLower.contains('tba')) {
      return CupertinoColors.systemOrange;
    } else if (statusLower.contains('airing') ||
        statusLower.contains('ongoing') ||
        statusLower.contains('current')) {
      return CupertinoColors.activeBlue;
    } else if (statusLower.contains('cancelled') ||
        statusLower.contains('canceled')) {
      return CupertinoColors.systemRed;
    }
    return CupertinoColors.systemGrey;
  }

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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStatusColor().withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
