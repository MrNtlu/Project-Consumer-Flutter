import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/actor/actor_content_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';

class PreviewActorList extends StatelessWidget {
  const PreviewActorList({super.key});

  @override
  Widget build(BuildContext context) {
    final PreviewProvider previewProvider = Provider.of<PreviewProvider>(context);
    final ContentProvider contentProvider = Provider.of<ContentProvider>(context);

    return SizedBox(
      height: 140,
      child: previewProvider.networkState == NetworkState.success 
      ? ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contentProvider.selectedContent == ContentType.movie 
          ? previewProvider.moviePreview.actors?.length 
          : previewProvider.tvPreview.actors?.length,
        itemBuilder: (context, index) {
          final actor = contentProvider.selectedContent == ContentType.movie 
            ? previewProvider.moviePreview.actors![index] 
            : previewProvider.tvPreview.actors![index];

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                return ActorContentPage(
                  actor.tmdbID,
                  actor.name,
                  actor.image,
                  isMovie: contentProvider.selectedContent == ContentType.movie
                );
              }));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 12, left: index == 0 ? 3 : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: actor.image?.replaceFirst("original", "w200") ?? '',
                        cacheKey: actor.image,
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.cover,
                        maxHeightDiskCache: 350,
                        maxWidthDiskCache: 350,
                        errorListener: (_){},
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
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 100,
                    child: AutoSizeText(
                      actor.name,
                      maxLines: 2,
                      maxFontSize: 16,
                      minFontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
      : ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          20,
          (index) => Padding(
            padding: EdgeInsets.only(right: 12, left: index == 0 ? 3 : 0),
            child: Shimmer.fromColors(
              baseColor: CupertinoColors.systemGrey,
              highlightColor: CupertinoColors.systemGrey3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: const ColoredBox(color: CupertinoColors.systemGrey),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 100,
                    height: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const ColoredBox(color: CupertinoColors.systemGrey)
                    ),
                  ),
                ],
              ),
            ),
          )
        )
      )
    );
  }
}