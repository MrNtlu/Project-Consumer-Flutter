import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/pages/main/discover/movie_discover_list_page.dart';
import 'package:watchlistfy/pages/main/discover/tv_discover_list_page.dart';
import 'package:watchlistfy/static/constants.dart';

class PreviewCountryList extends StatelessWidget {
  final bool isMovie;
  const PreviewCountryList({required this.isMovie, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: (isMovie ? Constants.MoviePopularCountries : Constants.TVPopularCountries).length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final country = (isMovie ? Constants.MoviePopularCountries : Constants.TVPopularCountries)[index];

          return Padding(
            padding: EdgeInsets.only(right: 12, left: index == 0 ? 3 : 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    if (isMovie) {
                      return MovieDiscoverListPage(country: country.request);
                    } else {
                      return TVDiscoverListPage(country: country.request);
                    }
                  })
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 96,
                  height: 75,
                  child: Stack(
                    children: [
                      CountryFlag.fromCountryCode(
                        country.request,
                        width: 96,
                        height: 75,
                      ),
                      SizedBox(
                        width: 96,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ColoredBox(
                            color: CupertinoColors.black.withOpacity(0.6),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                child: Text(
                                  country.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}