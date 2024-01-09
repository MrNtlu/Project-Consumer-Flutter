import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class ProfileConsumeLaterCell extends StatelessWidget {
  final String url;
  final String title;
  final VoidCallback onTap;

  const ProfileConsumeLaterCell(
    this.url, 
    this.title,
    this.onTap,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2/3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            ContentCell(url, title),
            Positioned(
              top: -3,
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: const Icon(CupertinoIcons.bookmark_fill, size: 32)
              ),
            )
          ],
        ),
      ),
    );
  }
}