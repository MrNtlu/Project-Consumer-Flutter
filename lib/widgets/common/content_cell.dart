import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';

class ContentCell extends StatelessWidget {
  final double height;
  final String url;

  const ContentCell(this.url, {this.height = 200, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context);

    return SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: provider.selectedContent != ContentType.game ? 2/3 : 16/9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network( //TODO No Image Handle and Name tag if game
            url,
            key: ValueKey<String>(url),
            fit: provider.selectedContent != ContentType.game ? BoxFit.contain : BoxFit.fill,
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: CupertinoColors.systemGrey, 
                highlightColor: CupertinoColors.systemGrey3,
                child: child
              );
            },
          ),
        ),
      ),
    );
  }
}
