import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/pages/main/actor/actor_content_page.dart';

class DetailsCommonList extends StatelessWidget {
  final bool isAvatar;
  final int listCount;
  final IconData placeHolderIcon;
  final String Function(int)? getActorID;
  final String? Function(int) getImage;
  final String Function(int) getName;
  final String Function(int)? getCharacter;
  final bool isMovie;

  const DetailsCommonList(
    this.isAvatar, this.listCount, this.getActorID, this.getImage,
    this.getName, this.getCharacter, this.isMovie, {this.placeHolderIcon = Icons.person, super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listCount,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final image = getImage(index);
        final name = getName(index);

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 100,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                image != null
                ? (isAvatar
                  ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (getActorID != null) {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            return ActorContentPage(
                              getActorID!(index),
                              name,
                              image,
                              isMovie: isMovie,
                            );
                          },
                        ));
                      }
                    },
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          key: ValueKey<String>(image),
                          cacheKey: image,
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover,
                          maxHeightDiskCache: 200,
                          maxWidthDiskCache: 200,
                          errorListener: (_) {},
                          errorWidget: (context, _, __) {
                            return const ColoredBox(color: CupertinoColors.systemGrey);
                          },
                          progressIndicatorBuilder: (_, __, ___) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Shimmer.fromColors(
                              baseColor: CupertinoColors.systemGrey, 
                              highlightColor: CupertinoColors.systemGrey3,
                              child: const ColoredBox(color: CupertinoColors.systemGrey,)
                            )
                          ),
                        ),
                      ),
                    ),
                  )
                  : Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      key: ValueKey<String>(image),
                      cacheKey: image,
                      height: 64,
                      maxHeightDiskCache: 200,
                      maxWidthDiskCache: 200,
                      errorListener: (_) {},
                    ),
                  )
                )
                : Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    placeHolderIcon, 
                    size: 64, 
                    color: CupertinoColors.black
                  ),
                ),
                const SizedBox(height: 6),
                AutoSizeText(
                  name,
                  maxLines: isAvatar ? 1 : 2,
                  maxFontSize: 16,
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                if (getCharacter != null)
                  AutoSizeText(
                    getCharacter!(index),
                    maxLines: 1,
                    maxFontSize: 14,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  )
              ],
            ),
          ),
        );
      }
    );
  }
}