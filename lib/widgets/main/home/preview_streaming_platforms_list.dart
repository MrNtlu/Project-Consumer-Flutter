import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/streaming/streaming_content_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class PreviewStreamingPlatformsList extends StatelessWidget {
  final String region;

  const PreviewStreamingPlatformsList(this.region, {super.key});

  @override
  Widget build(BuildContext context) {
    final PreviewProvider previewProvider = Provider.of<PreviewProvider>(context);
    final ContentProvider contentProvider = Provider.of<ContentProvider>(context);

    return SizedBox(
      height: 75,
      child: previewProvider.networkState == NetworkState.success
      ? ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contentProvider.selectedContent == ContentType.movie
          ? (previewProvider.moviePreview.streamingPlatforms?.length ?? 1)
          : (
            contentProvider.selectedContent == ContentType.tv
            ? (previewProvider.tvPreview.streamingPlatforms?.length ?? 1)
            : previewProvider.animePreview.animeStreamingPlatforms?.length
          ),
        itemBuilder: (context, index) {
          final isMovie = contentProvider.selectedContent == ContentType.movie;
          final isTV = contentProvider.selectedContent == ContentType.tv;

          if ((isMovie && previewProvider.moviePreview.streamingPlatforms == null) || (isTV && previewProvider.tvPreview.streamingPlatforms == null)) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Center(child: Text("Not available in your region."))
            );
          }

          final streamingPlatform = isMovie
            ? previewProvider.moviePreview.streamingPlatforms![index]
            : isTV ? previewProvider.tvPreview.streamingPlatforms![index] : null;

          final animeStreamingPlatform = !(isMovie || isTV)
            ? previewProvider.animePreview.animeStreamingPlatforms![index]
            : null;

          return GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                return StreamingContentPage(
                  region,
                  streamingPlatform?.name ?? animeStreamingPlatform!.name,
                  streamingPlatform?.logo ?? 'https://logo.clearbit.com/${animeStreamingPlatform?.url}',
                  isMovie: isMovie,
                  isAnime: !(isMovie || isTV),
                );
              }));
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
                        imageUrl: streamingPlatform?.logo ?? 'https://logo.clearbit.com/${animeStreamingPlatform?.url}',
                        cacheKey: streamingPlatform?.logo ?? 'https://logo.clearbit.com/${animeStreamingPlatform?.url}',
                        filterQuality: FilterQuality.low,
                        fit: BoxFit.cover,
                        maxHeightDiskCache: 200,
                        maxWidthDiskCache: 200,
                        errorListener: (_){},
                        placeholder: (context, _) {
                          return ColoredBox(
                            color: CupertinoTheme.of(context).bgTextColor,
                            child: SizedBox(
                              height: 75,
                              width: 75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: AutoSizeText(
                                    streamingPlatform?.name ?? animeStreamingPlatform!.name,
                                    minFontSize: 13,
                                    style: TextStyle(color: CupertinoTheme.of(context).bgColor, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, _, __) {
                          return ColoredBox(
                            color: CupertinoTheme.of(context).bgTextColor,
                            child: SizedBox(
                              height: 75,
                              width: 75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: AutoSizeText(
                                    streamingPlatform?.name ?? animeStreamingPlatform!.name,
                                    minFontSize: 13,
                                    style: TextStyle(
                                      color: CupertinoTheme.of(context).bgColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                            ),
                          );
                        },
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
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}