import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/discover/discover_movie_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_filter_body.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class MovieDiscoverSheet extends StatelessWidget {
  final VoidCallback fetchData;
  final DiscoverMovieProvider provider;

  const MovieDiscoverSheet(this.fetchData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortRequests.where((element) => element.request == provider.sort).first.name,
      Constants.SortRequests.map((e) => e.name).toList(),
      allowUnSelect: false,
    );

    final genres = Constants.MovieGenreList.map((e) => e.name).toList();
    genres.removeAt(0);
    final genreList = DiscoverSheetList(
      Constants.MovieGenreList.where((element) => element.name == provider.genre).firstOrNull?.name,
      genres,
    );

    final statusList = DiscoverSheetList(
      Constants.MovieStatusRequests.where((element) => element.request == provider.status).firstOrNull?.name,
      Constants.MovieStatusRequests.map((e) => e.name).toList()
    );

    final decadeList = DiscoverSheetList(
      Constants.DecadeList.where((element) => element.request == provider.decade).firstOrNull?.name,
      Constants.DecadeList.map((e) => e.name).toList()
    );

    return SafeArea(
      child: Container(
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  DiscoverSheetFilterBody("Sort", sortList),
                  DiscoverSheetFilterBody("Genre", genreList),
                  DiscoverSheetFilterBody("Status", statusList),
                  DiscoverSheetFilterBody("Release Date", decadeList),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  child: const Text("Reset", style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 14)), 
                  onPressed: () {
                    Navigator.pop(context);
                    provider.reset();
                    fetchData();
                  }
                ),
                CupertinoButton.filled(
                  onPressed: () {
                    Navigator.pop(context);
                    provider.setDiscover(
                      sort: Constants.SortRequests.where((element) => element.name == sortList.selectedValue!).first.request,
                      genre: Constants.MovieGenreList.where((element) => element.name == genreList.selectedValue).firstOrNull?.name,
                      status: Constants.MovieStatusRequests.where((element) => element.name == statusList.selectedValue).firstOrNull?.request,
                      decade: Constants.DecadeList.where((element) => element.name == decadeList.selectedValue).firstOrNull?.request,
                    );
                    fetchData();
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 16)
                  ), 
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}