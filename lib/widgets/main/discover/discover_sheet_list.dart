import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

class DiscoverSheetList extends StatelessWidget {
  final ValueNotifier<String?> selectedValueNotifier;
  final String? initialValue;
  final List<String> list;
  final List<IconData>? iconList;
  final bool allowUnSelect;

  DiscoverSheetList(
    this.initialValue,
    this.list, {
    this.allowUnSelect = true,
    this.iconList,
    super.key,
  }) : selectedValueNotifier = ValueNotifier(initialValue);

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final data = list[index];

        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 6 : 0,
          ),
          child: ValueListenableBuilder(
            valueListenable: selectedValueNotifier,
            builder: (context, selectedVal, child) {
              return CupertinoChip(
                shouldShowBorder: true,
                isSelected: data == selectedVal,
                leading: iconList != null
                    ? Icon(
                        size: 20,
                        iconList![index],
                        color: data == selectedVal
                            ? CupertinoColors.white
                            : cupertinoTheme.bgTextColor,
                      )
                    : null,
                label: data,
                onSelected: (value) {
                  if (data != selectedVal) {
                    selectedValueNotifier.value = data;
                  } else if (allowUnSelect) {
                    selectedValueNotifier.value = null;
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
