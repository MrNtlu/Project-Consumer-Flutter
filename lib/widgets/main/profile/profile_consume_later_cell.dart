import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class ProfileConsumeLaterCell extends StatelessWidget {
  final String url;
  final String title;
  final VoidCallback onTap;

  const ProfileConsumeLaterCell(
    this.url, 
    this.title,
    this.onTap,
    {
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2/3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            ContentCell(url, title, forceRatio: true, cacheWidth: 300, cacheHeight: 400,),
            Positioned(
              top: -3,
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.5),
                        spreadRadius: 2.3,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(CupertinoIcons.bookmark_fill, size: 32, color: AppColors().primaryColor)
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}