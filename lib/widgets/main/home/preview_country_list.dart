import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';

class PreviewCountryList extends StatelessWidget {
  final bool isMovie;
  const PreviewCountryList({required this.isMovie, super.key});

  // If emoji needed
  // String _flagEmoji(String countryCode) {
  //   return countryCode
  //       .toUpperCase()
  //       .codeUnits
  //       .map((unit) => String.fromCharCode(unit + 0x1F1E6 - 65))
  //       .join();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102,
      child: ListView.builder(
        itemCount: (isMovie
                ? Constants.MoviePopularCountries
                : Constants.TVPopularCountries)
            .length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final country = (isMovie
              ? Constants.MoviePopularCountries
              : Constants.TVPopularCountries)[index];

          final isLast = index ==
              (isMovie
                  ? Constants.MoviePopularCountries.length - 1
                  : Constants.TVPopularCountries.length - 1);

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 6 : 8,
              right: isLast ? 16 : 8,
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) {
                    return isMovie
                        ? MovieDiscoverListPage(country: country.request)
                        : TVDiscoverListPage(country: country.request);
                  },
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoTheme.of(context).profileButton,
                    ),
                    alignment: Alignment.center,
                    child: CountryFlag.fromCountryCode(
                      country.request,
                      width: 30,
                      height: 24,
                      borderRadius: 4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 72,
                    child: Text(
                      country.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CupertinoTheme.of(context).bgTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
