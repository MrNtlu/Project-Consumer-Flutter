import 'package:auto_size_text/auto_size_text.dart';
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
  bool isStreamingRegionFiltered;
  final Function(bool) onStreamingRegionFilteredChanged;

  DiscoverSheetRegionSelection(
    this.streamingRegion,
    {
      required this.isStreamingRegionFiltered,
      required this.onStreamingRegionFilteredChanged,
      super.key
    }
  );

  @override
  State<DiscoverSheetRegionSelection> createState() => _DiscoverSheetRegionSelectionState();
}

class _DiscoverSheetRegionSelectionState extends State<DiscoverSheetRegionSelection> {
  late bool isStreamingRegionFiltered;

  void _toggleStreamingRegionFiltered() {
    setState(() {
      isStreamingRegionFiltered = !isStreamingRegionFiltered;
      widget.onStreamingRegionFilteredChanged(isStreamingRegionFiltered);
    });
  }

  @override
  void initState() {
    super.initState();
    isStreamingRegionFiltered = widget.isStreamingRegionFiltered;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DetailsTitle("Streaming Platform Region"),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width - (MediaQuery.orientationOf(context) == Orientation.landscape ? 42 : 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 45,
                        width: 200,
                        child: CupertinoChip(
                          isSelected: isStreamingRegionFiltered,
                          onSelected: (value) {
                            _toggleStreamingRegionFiltered();
                          },
                          label: "Filter by Region ${isStreamingRegionFiltered ? "Active" : "Deactive"}",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 37,
                            child: CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              minSize: 0,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CountryFlag.fromCountryCode(
                                    widget.streamingRegion,
                                    width: 22,
                                    height: 15,
                                    borderRadius: 4,
                                  ),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: AutoSizeText(
                                      Country.tryParse(widget.streamingRegion)?.name ?? widget.streamingRegion,
                                      minFontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: CupertinoTheme.of(context).bgTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                showCountryPicker(
                                  context: context,
                                  useSafeArea: true,
                                  showPhoneCode: false,
                                  countryFilter: [
                                    "AE","AT","AU","AZ","BE","BR","CA","CH","DE",
                                    "DK","EG","ES","FR","GB","HK","IN","IT","JP",
                                    "KR","MX","NL","NO","PH","PT","RU","SA","SE",
                                    "TR","TW","US","VN"
                                  ],
                                  showSearch: false,
                                  countryListTheme: CountryListThemeData(
                                    flagSize: 35,
                                    backgroundColor: CupertinoTheme.of(context).onBgColor,
                                    searchTextStyle: TextStyle(fontSize: 16, color: CupertinoTheme.of(context).bgTextColor),
                                    textStyle: TextStyle(fontSize: 16, color: CupertinoTheme.of(context).bgTextColor),
                                    bottomSheetHeight: 500,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                    inputDecoration: InputDecoration(
                                      labelText: 'Search',
                                      hintText: 'Start typing to search',
                                      hintStyle: const TextStyle(color: CupertinoColors.systemGrey2),
                                      prefixIcon: const Icon(CupertinoIcons.search),
                                      prefixIconColor: CupertinoTheme.of(context).bgTextColor,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: CupertinoTheme.of(context).bgTextColor.withOpacity(0.5),
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
                              }
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ));
  }
}