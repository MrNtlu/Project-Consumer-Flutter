import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class DetailsRecommendationList extends StatelessWidget {
  final int itemCount;
  final String Function(int) getImage;
  final String Function(int) getTitle;
  final Widget Function(int) onTap;

  const DetailsRecommendationList(
    this.itemCount, this.getImage, 
    this.getTitle, this.onTap, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {    
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) {
                  return onTap(index);
                }
              , maintainState: false));
            },
            child: ContentCell(
              getImage(index), 
              getTitle(index),
              cornerRadius: 8,
              cacheHeight: 425,
              cacheWidth: 350,
            )
          ),
        );
      }
    );
  }
}