import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class PreviewList extends StatefulWidget {
  final String contentTag;

  const PreviewList(this.contentTag, {super.key});

  @override
  State<PreviewList> createState() => _PreviewListState();
}

class _PreviewListState extends State<PreviewList> {
  bool isInitialized = false;
  late final PreviewProvider _previewProvider;
  late final ContentProvider _contentProvider;
  late final ScrollController _scrollController;

  void onContentChange() {
    _scrollController.jumpTo(0);
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      _scrollController = ScrollController();
      _previewProvider = Provider.of<PreviewProvider>(context);
      _contentProvider = Provider.of<ContentProvider>(context);
      _contentProvider.addListener(onContentChange);
      isInitialized = true;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentProvider.removeListener(onContentChange);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int listCount;

    if (_previewProvider.networkState == NetworkState.success) {
      BasePreviewResponse<BaseContent> preview;

      switch (_contentProvider.selectedContent) {
        case ContentType.movie:
          preview = _previewProvider.moviePreview;
          break;
        case ContentType.tv:
          preview = _previewProvider.tvPreview;
          break;
        case ContentType.anime:
          preview = _previewProvider.animePreview;
          break;
        default:
          preview = _previewProvider.gamePreview;
          break;
      }

      switch (widget.contentTag) {
        case "popular":
          listCount = preview.popular.length;
          break;
        case "upcoming":
          listCount = preview.upcoming.length;
          break;
        case "extra":
          listCount = preview.extra?.length ?? 0;
          break;
        default:
          listCount = preview.top.length;
          break;
      }
    } else {
      listCount = 20;
    }

    return _previewProvider.networkState == NetworkState.success
    ? ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: listCount,
        itemBuilder: (context, index) {
          BasePreviewResponse<BaseContent> preview;
          BaseContent data;

          switch (_contentProvider.selectedContent) {
            case ContentType.movie:
              preview = _previewProvider.moviePreview;
              break;
            case ContentType.tv:
              preview = _previewProvider.tvPreview;
              break;
            case ContentType.anime:
              preview = _previewProvider.animePreview;
              break;
            default:
              preview = _previewProvider.gamePreview;
              break;
          }

          switch (widget.contentTag) {
            case "popular":
              data = preview.popular[index];
              break;
            case "upcoming":
              data = preview.upcoming[index];
              break;
            case "extra":
              data = preview.extra![index];
              break;
            default:
              data = preview.top[index];
              break;
          }
          return GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(builder: (_) {
                switch (_contentProvider.selectedContent) {
                  case ContentType.movie:
                    return MovieDetailsPage(data.id);
                  case ContentType.tv:
                    return TVDetailsPage(data.id);
                  case ContentType.anime:
                    return AnimeDetailsPage(data.id);
                  case ContentType.game:
                    return GameDetailsPage(data.id);
                  default:
                    return MovieDetailsPage(data.id);
                }
              }));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: SizedBox(
                height: 200,
                child: ContentCell(data.imageUrl.replaceFirst("original", "w200"), data.titleEn)
              ),
            ),
          );
        },
      )
    : ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          listCount,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: SizedBox(
              height: 200,
              child: AspectRatio(
                aspectRatio: _contentProvider.selectedContent != ContentType.game
                ? 2 / 3
                : 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Shimmer.fromColors(
                    baseColor: CupertinoColors.systemGrey,
                    highlightColor: CupertinoColors.systemGrey3,
                    child: Container(
                      color: CupertinoColors.systemGrey,
                    )
                  )
                ),
              ),
            ),
          )
        )
      );
  }
}
