import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

// ignore: must_be_immutable
class DiscoverSheetCountryList extends StatefulWidget {
  String? selectedValue;
  final List<String> list;
  final List<String> countryCodeList;

  DiscoverSheetCountryList(this.selectedValue, this.list, this.countryCodeList, {super.key});

  @override
  State<DiscoverSheetCountryList> createState() => _DiscoverSheetCountryListState();
}

class _DiscoverSheetCountryListState extends State<DiscoverSheetCountryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        final data = widget.list[index];
        final countryCode = widget.countryCodeList[index];

        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 6 : 0),
          child: CupertinoChip(
            isSelected: data == widget.selectedValue,
            leading: CountryFlag.fromCountryCode(
              countryCode,
              width: 25,
              height: 20,
              borderRadius: 4,
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
