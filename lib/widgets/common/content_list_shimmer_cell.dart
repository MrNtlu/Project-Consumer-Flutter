import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';

class ContentListShimmerCell extends StatelessWidget {
  final ContentType _contentType;
  const ContentListShimmerCell(this._contentType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey,
      highlightColor: CupertinoColors.systemGrey3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
        child: Row(
          children: [
            SizedBox(
              height: 135,
              width: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const ColoredBox(color: CupertinoColors.systemGrey,)
              )
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const ColoredBox(color: CupertinoColors.systemGrey)
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      width: double.infinity,
                      height: 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const ColoredBox(color: CupertinoColors.systemGrey)
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const ColoredBox(color: CupertinoColors.systemGrey)
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.star_fill, size: 14),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 25,
                          height: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const ColoredBox(color: CupertinoColors.systemGrey)
                          ),
                        ),
                        const SizedBox(width: 12),
                        FaIcon(
                          _contentType != ContentType.game
                          ? FontAwesomeIcons.ticket
                          : FontAwesomeIcons.gamepad,
                        size: 14),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: 75,
                          height: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const ColoredBox(color: CupertinoColors.systemGrey)
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
              )
            )
          ]
        ),
      )
    );
  }
}