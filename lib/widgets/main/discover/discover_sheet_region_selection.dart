import 'package:country_flags/country_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

// ignore: must_be_immutable
class DiscoverSheetRegionSelection extends StatefulWidget {
  String streamingRegion;

  DiscoverSheetRegionSelection(this.streamingRegion, {super.key});

  @override
  State<DiscoverSheetRegionSelection> createState() =>
      _DiscoverSheetRegionSelectionState();
}

class _DiscoverSheetRegionSelectionState
    extends State<DiscoverSheetRegionSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DetailsTitle("Streaming Platform Region"),
                ),
                SizedBox(
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CupertinoChip(
                      shouldShowBorder: true,
                      isSelected: widget.streamingRegion != "WW",
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      leading: widget.streamingRegion != "WW"
                          ? CountryFlag.fromCountryCode(
                              widget.streamingRegion,
                              width: 25,
                              height: 20,
                              borderRadius: 4,
                            )
                          : const Text("🌎", style: TextStyle(fontSize: 18)),
                      label: Country.tryParse(widget.streamingRegion)?.name ??
                          widget.streamingRegion,
                      onSelected: (_) {
                        showCountryPicker(
                          context: context,
                          useSafeArea: true,
                          showPhoneCode: false,
                          showWorldWide: true,
                          countryFilter: [
                            "AE",
                            "AT",
                            "AU",
                            "AZ",
                            "BE",
                            "BR",
                            "CA",
                            "CH",
                            "DE",
                            "DK",
                            "EG",
                            "ES",
                            "FR",
                            "GB",
                            "HK",
                            "IN",
                            "IT",
                            "JP",
                            "KR",
                            "MX",
                            "NL",
                            "NO",
                            "PH",
                            "PT",
                            "RU",
                            "SA",
                            "SE",
                            "TR",
                            "TW",
                            "US",
                            "VN"
                          ],
                          showSearch: false,
                          countryListTheme: CountryListThemeData(
                            flagSize: 35,
                            backgroundColor:
                                CupertinoTheme.of(context).onBgColor,
                            searchTextStyle: TextStyle(
                                fontSize: 16,
                                color: CupertinoTheme.of(context).bgTextColor),
                            textStyle: TextStyle(
                                fontSize: 16,
                                color: CupertinoTheme.of(context).bgTextColor),
                            bottomSheetHeight: 500,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            inputDecoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Start typing to search',
                              hintStyle: const TextStyle(
                                  color: CupertinoColors.systemGrey2),
                              prefixIcon: const Icon(CupertinoIcons.search),
                              prefixIconColor:
                                  CupertinoTheme.of(context).bgTextColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CupertinoTheme.of(context)
                                      .bgTextColor
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              widget.streamingRegion = country.countryCode;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
