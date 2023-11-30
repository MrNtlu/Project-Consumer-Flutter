import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class ContentCell extends StatelessWidget {
  final double height;
  final String url;

  const ContentCell(this.url, {this.height = 200, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: 2/3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            fit: BoxFit.contain,
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
