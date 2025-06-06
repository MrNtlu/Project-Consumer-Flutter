import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class ContentList extends StatelessWidget {
  final ScrollController _scrollController;
  final bool _canPaginate;
  final bool _isPaginating;
  final bool _isMovie;
  final bool isAnime;
  final List<BaseContent> data;

  const ContentList(this._scrollController, this._canPaginate,
      this._isPaginating, this._isMovie, this.data,
      {this.isAnime = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GridView.builder(
        itemCount: _canPaginate ? data.length + 2 : data.length,
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          if ((_canPaginate || _isPaginating) && index >= data.length) {
            return AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Shimmer.fromColors(
                  baseColor: CupertinoColors.systemGrey,
                  highlightColor: CupertinoColors.systemGrey3,
                  child: const ColoredBox(
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            );
          }

          final content = data[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) {
                    if (_isMovie) {
                      return DetailsPage(
                        id: content.id,
                        contentType: ContentType.movie,
                      );
                    } else if (isAnime) {
                      return DetailsPage(
                        id: content.id,
                        contentType: ContentType.anime,
                      );
                    } else {
                      return DetailsPage(
                        id: content.id,
                        contentType: ContentType.tv,
                      );
                    }
                  },
                  maintainState: NavigationTracker().shouldMaintainState(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
              child: ContentCell(
                content.imageUrl,
                content.titleEn,
                forceRatio: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
