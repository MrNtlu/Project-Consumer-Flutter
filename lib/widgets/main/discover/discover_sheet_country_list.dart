import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

class DiscoverSheetCountryList extends StatelessWidget {
  final String? initialValue;
  final ValueNotifier<String?> selectedValueNotifier;
  final List<String> list;
  final List<String> countryCodeList;

  DiscoverSheetCountryList(
    this.initialValue,
    this.list,
    this.countryCodeList, {
    super.key,
  }) : selectedValueNotifier = ValueNotifier(initialValue);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final data = list[index];
        final countryCode = countryCodeList[index];

        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 6 : 0),
          child: ValueListenableBuilder(
            valueListenable: selectedValueNotifier,
            builder: (context, selectedValue, child) {
              return CupertinoChip(
                shouldShowBorder: true,
                isSelected: data == selectedValue,
                leading: CountryFlag.fromCountryCode(
                  countryCode,
                  width: 25,
                  height: 20,
                  borderRadius: 4,
                ),
                label: data,
                onSelected: (value) {
                  if (data != selectedValue) {
                    selectedValueNotifier.value = data;
                  } else {
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
