import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/base_content.dart';
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

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      _previewProvider = Provider.of<PreviewProvider>(context); 
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
          BaseContent data;

          switch (widget.contentTag) {
            case "popular":
              data = _previewProvider.moviePreview.popular[index];
              break;
            case "upcoming":
              data = _previewProvider.moviePreview.upcoming[index];
              break;
            case "extra":
              data = _previewProvider.moviePreview.extra![index];
              break;
            default:
              data = _previewProvider.moviePreview.top[index];
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
