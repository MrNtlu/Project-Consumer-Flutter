import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:myanilist/services/cache_manager_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/providers/main/discover/discover_streaming_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/cupertino_streaming_chip.dart';

// ignore: must_be_immutable
class DiscoverSheetImageList extends StatefulWidget {
  String? selectedValue;
  final List<String> list;
  final List<String> imageList;
  final bool isBiggerAndWideImage;
  StreamingPlatformStateProvider? provider;

  DiscoverSheetImageList(
    this.selectedValue,
    this.list,
    this.imageList,
    {
      this.provider,
      this.isBiggerAndWideImage = false,
      super.key
    }
  );

  @override
  State<DiscoverSheetImageList> createState() => _DiscoverSheetImageListState();
}

class _DiscoverSheetImageListState extends State<DiscoverSheetImageList> {
  bool isInit = false;
  late final StreamingPlatformStateProvider provider;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      provider = Provider.of<StreamingPlatformStateProvider>(context);
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return provider.isExpanded == true
    ? SizedBox(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        runSpacing: 3,
        children: List.generate(
          widget.list.length,
          (index) {
            final data = widget.list[index];
            final image = widget.imageList[index];

            return SizedBox(
              height: 45,
              child: UnconstrainedBox(
                constrainedAxis: Axis.vertical,
                child: CupertinoStreamingChip(
                  isSelected: data == widget.selectedValue,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.isBiggerAndWideImage ? 8 : 13),
                    child: ColoredBox(
                      color: widget.isBiggerAndWideImage ? CupertinoColors.white : CupertinoTheme.of(context).bgColor,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        key: ValueKey<String>(image),
                        cacheKey: image,
                        height: 25,
                        width: widget.isBiggerAndWideImage ? 35 : 25,
                        fit: widget.isBiggerAndWideImage ? BoxFit.contain : BoxFit.cover,
                        cacheManager: CustomCacheManager.instance,
                        maxHeightDiskCache: 75,
                        maxWidthDiskCache: widget.isBiggerAndWideImage ? 105 : 75,
                        progressIndicatorBuilder: (_, __, ___) => ClipRRect(
                          borderRadius: BorderRadius.circular(widget.isBiggerAndWideImage ? 8 : 13),
                          child: Shimmer.fromColors(
                            baseColor: CupertinoColors.systemGrey,
                            highlightColor: CupertinoColors.systemGrey3,
                            child: const ColoredBox(color: CupertinoColors.systemGrey)
                          )
                        ),
                        errorListener: (_) {},
                      ),
                    ),
                  ),
                  label: data,
                  onSelected: (value) {
                    setState(() {
                      if (data != widget.selectedValue) {
                        widget.selectedValue = data;
                      } else {
                        widget.selectedValue = null;
                      }
                    });
                  }
                ),
              ),
            );
          }
        )
      ),
    )
    : SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          final data = widget.list[index];
          final image = widget.imageList[index];

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 6 : 0),
            child: CupertinoChip(
              isSelected: data == widget.selectedValue,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: ColoredBox(
                  color: widget.isBiggerAndWideImage ? CupertinoColors.white : CupertinoTheme.of(context).bgColor,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    key: ValueKey<String>(image),
                    cacheKey: image,
                    height: 25,
                    width: 25,
                    fit: widget.isBiggerAndWideImage ? BoxFit.contain : BoxFit.cover,
                    cacheManager: CustomCacheManager.instance,
                    maxHeightDiskCache: 75,
                    maxWidthDiskCache: 75,
                    progressIndicatorBuilder: (_, __, ___) => ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Shimmer.fromColors(
                        baseColor: CupertinoColors.systemGrey,
                        highlightColor: CupertinoColors.systemGrey3,
                        child: const ColoredBox(color: CupertinoColors.systemGrey)
                      )
                    ),
                    errorListener: (_) {},
                  ),
                ),
              ),
              label: data,
              onSelected: (value) {
                setState(() {
                  if (data != widget.selectedValue) {
                    widget.selectedValue = data;
                  } else {
                    widget.selectedValue = null;
                  }
                });
              }
            ),
          );
        }
      ),
    );
  }
}

