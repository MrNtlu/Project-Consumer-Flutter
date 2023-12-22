import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:watchlistfy/static/colors.dart';

class ContentCell extends StatelessWidget {
  final String url;
  final String title;
  final double cornerRadius;

  const ContentCell(this.url, this.title, {this.cornerRadius = 12, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context);

    return AspectRatio(
      aspectRatio: provider.selectedContent != ContentType.game ? 2/3 : 16/9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: provider.selectedContent == ContentType.game
        ? Stack(children: [
          _image(provider.selectedContent),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: ColoredBox(
                color: CupertinoColors.black.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.white),
                  ),
                )
              ),
            ),
          )
        ],)
        : _image(provider.selectedContent),
      ),
    );
  }

  Widget _image(ContentType selectedContent) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: url + title,
      filterQuality: FilterQuality.low,
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutDuration: const Duration(milliseconds: 0),
      key: ValueKey<String>(url + title),
      fit: selectedContent != ContentType.game ? BoxFit.contain : BoxFit.fill,
      progressIndicatorBuilder: (_, __, ___) => AspectRatio(
        aspectRatio: selectedContent != ContentType.game ? 2/3 : 16/9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Shimmer.fromColors(
            baseColor: CupertinoColors.systemGrey, 
            highlightColor: CupertinoColors.systemGrey3,
            child: Container(color: CupertinoColors.systemGrey,)
          )
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: CupertinoTheme.of(context).bgTextColor,
        child: AspectRatio(
          aspectRatio: selectedContent != ContentType.game ? 2/3 : 16/9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoTheme.of(context).bgColor,
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
