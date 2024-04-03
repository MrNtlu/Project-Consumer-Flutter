import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/main/discover/discover_streaming_provider.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_country_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_image_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_premium_list.dart';

class DiscoverSheetFilterBody extends StatelessWidget {
  final String title;
  final DiscoverSheetList sheetList;

  const DiscoverSheetFilterBody(this.title, this.sheetList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DetailsTitle(title),
          ),
          SizedBox(
            height: 45,
            child: sheetList
          )
        ],
      ),
    );
  }
}

class DiscoverSheetImageFilterBody extends StatelessWidget {
  final String title;
  final DiscoverSheetImageList sheetList;

  const DiscoverSheetImageFilterBody(
    this.title,
    this.sheetList,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StreamingPlatformStateProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: DetailsTitle(title)
                  )
                ),
                SizedBox(
                  height: 50,
                  child: CupertinoButton(
                    minSize: 0,
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          provider.isExpanded
                          ? FontAwesomeIcons.compress
                          : FontAwesomeIcons.expand,
                          size: 17,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          provider.isExpanded ? "Collapse" : "Expand",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    onPressed: (){
                      provider.toggleState();
                    },
                  ),
                )
              ],
            ),
          ),
          sheetList
        ],
      ),
    );
  }
}

class DiscoverSheetCountryFilterBody extends StatelessWidget {
  final String title;
  final DiscoverSheetCountryList sheetList;

  const DiscoverSheetCountryFilterBody(this.title, this.sheetList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DetailsTitle(title),
          ),
          SizedBox(
            height: 45,
            child: sheetList
          )
        ],
      ),
    );
  }
}

class DiscoverSheetFilterPremiumBody extends StatelessWidget {
  final String title;
  final DiscoverSheetPremiumList sheetList;

  const DiscoverSheetFilterPremiumBody(this.title, this.sheetList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DetailsTitle(title),
          ),
          SizedBox(
            height: 45,
            child: sheetList
          )
        ],
      ),
    );
  }
}