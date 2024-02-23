import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';

class PreviewStreamingPlatformsList extends StatelessWidget {
  const PreviewStreamingPlatformsList({super.key});

  @override
  Widget build(BuildContext context) {
    final PreviewProvider previewProvider = Provider.of<PreviewProvider>(context);
    final ContentProvider contentProvider = Provider.of<ContentProvider>(context);

    return SizedBox(
      height: 115,
      child: previewProvider.networkState == NetworkState.success
      ? ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contentProvider.selectedContent == ContentType.movie 
          ? previewProvider.moviePreview.streamingPlatforms?.length 
          : previewProvider.tvPreview.streamingPlatforms?.length,
        itemBuilder: (context, index) {
          final streamingPlatform = contentProvider.selectedContent == ContentType.movie 
            ? previewProvider.moviePreview.streamingPlatforms![index] 
            : previewProvider.tvPreview.streamingPlatforms![index];

          return GestureDetector(
            onTap: () {
              //TODO Redirect to content page
              // Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
              //   return ;
              // }));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 12, left: index == 0 ? 3 : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: streamingPlatform.logo,
                        cacheKey: streamingPlatform.logo,
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.cover,
                        maxHeightDiskCache: 200,
                        maxWidthDiskCache: 200,
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
                      streamingPlatform.name,
                      maxLines: 2,
                      maxFontSize: 16,
                      minFontSize: 13,
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
                    height: 75,
                    width: 75,
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
      ),
    );
  }
}