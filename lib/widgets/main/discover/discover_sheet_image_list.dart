import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

// ignore: must_be_immutable
class DiscoverSheetImageList extends StatefulWidget {
  String? selectedValue;
  final List<String> list;
  final List<String> imageList;

  DiscoverSheetImageList(this.selectedValue, this.list, this.imageList, {super.key});

  @override
  State<DiscoverSheetImageList> createState() => _DiscoverSheetImageListState();
}

class _DiscoverSheetImageListState extends State<DiscoverSheetImageList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              child: CachedNetworkImage(
                imageUrl: image,
                key: ValueKey<String>(image),
                cacheKey: image,
                height: 25,
                width: 25,
                fit: BoxFit.cover,
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
    );
  }
}
