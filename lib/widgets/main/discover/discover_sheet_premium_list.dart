import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

class PremiumSheet {
  final String label;
  final bool isPremium;

  PremiumSheet(this.label, this.isPremium);
}

// ignore: must_be_immutable
class DiscoverSheetPremiumList extends StatefulWidget {
  String? selectedValue;
  final List<PremiumSheet> list;

  DiscoverSheetPremiumList(this.selectedValue, this.list, {super.key});

  @override
  State<DiscoverSheetPremiumList> createState() =>
      _DiscoverSheetPremiumListState();
}

class _DiscoverSheetPremiumListState extends State<DiscoverSheetPremiumList> {
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
                shouldShowBorder: true,
                isSelected: data.label == widget.selectedValue,
                label: data.label,
                leading: data.isPremium
                    ? Lottie.asset("assets/lottie/premium.json",
                        height: 24, width: 24, frameRate: const FrameRate(60))
                    : null,
                onSelected: (value) {
                  setState(() {
                    if (data.label != widget.selectedValue) {
                      widget.selectedValue = data.label;
                    }
                  });
                }),
          );
        });
  }
}
