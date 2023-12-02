import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
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

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      _previewProvider = Provider.of<PreviewProvider>(context); 
      _contentProvider = Provider.of<ContentProvider>(context);
      isInitialized = true;
    }
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _previewProvider.networkState == NetworkState.success
      ? ListView.builder(
        scrollDirection: Axis.horizontal,
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ContentCell(data.imageUrl),
          );
        },
      )
      : ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(20, (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SizedBox(
            height: 200,
            child: AspectRatio(
              aspectRatio: 2/3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Shimmer.fromColors(
                  baseColor: CupertinoColors.systemGrey, 
                  highlightColor: CupertinoColors.systemGrey3,
                  child: Container(color: CupertinoColors.systemGrey,)
                )
              ),
            ),
          ),
        )
      )
    );
  }
}
