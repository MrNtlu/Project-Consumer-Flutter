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
    final cupertinoTheme = CupertinoTheme.of(context);
    final countries = isMovie
        ? Constants.MoviePopularCountries
        : Constants.TVPopularCountries;

    return SizedBox(
      height: 160,
      child: ListView.builder(
        itemCount: countries.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final country = countries[index];

          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(left: 8, right: 6)
                : const EdgeInsets.symmetric(horizontal: 6),
            child: _buildCountryCard(
              context,
              country,
              cupertinoTheme,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCountryCard(
    BuildContext context,
    dynamic country,
    CupertinoThemeData theme,
  ) {
    return GestureDetector(
      onTap: () => _navigateToDiscoverPage(context, country),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: theme.onBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.bgTextColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.primaryColor.withValues(alpha: 0.1),
                            theme.primaryColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _buildFlagContainer(country, theme),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      country.name.isNotEmpty ? country.name : "Unknown",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.bgTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagContainer(dynamic country, CupertinoThemeData theme) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.scaffoldBackgroundColor,
        border: Border.all(
          color: theme.bgTextColor.withValues(alpha: 0.08),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.bgTextColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: CountryFlag.fromCountryCode(
        country.request,
        width: 28,
        height: 22,
        borderRadius: 2,
      ),
    );
  }

  void _navigateToDiscoverPage(BuildContext context, dynamic country) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) {
          return isMovie
              ? MovieDiscoverListPage(country: country.request)
              : TVDiscoverListPage(country: country.request);
        },
      ),
    );
  }
}
