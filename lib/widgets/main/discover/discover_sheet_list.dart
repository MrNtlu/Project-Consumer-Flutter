import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

// ignore: must_be_immutable
class DiscoverSheetList extends StatefulWidget {
  String? selectedValue;
  final List<String> list;

  DiscoverSheetList(this.selectedValue, this.list, {super.key});

  @override
  State<DiscoverSheetList> createState() => _DiscoverSheetListState();
}

class _DiscoverSheetListState extends State<DiscoverSheetList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        final data = widget.list[index];

        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 6 : 0),
          child: CupertinoChip(
            isSelected: data == widget.selectedValue,
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
