import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/providers/main/discover/discover_movie_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';
import 'package:watchlistfy/widgets/main/discover/discover_sheet_list.dart';

class MovieDiscoverSheet extends StatelessWidget {
  final VoidCallback fetchData;
  final DiscoverMovieProvider provider;

  const MovieDiscoverSheet(this.fetchData, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortList = DiscoverSheetList(
      Constants.SortRequests.where((element) => element.request == provider.sort).first.name,
      Constants.SortRequests.map((e) => e.name).toList()
    );

    final genreList = DiscoverSheetList(
      Constants.MovieGenreList.where((element) => element.name == provider.genre).firstOrNull?.name,
      Constants.MovieGenreList.map((e) => e.name).toList()
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
                  _filterBody("Sort", sortList),
                  _filterBody("Genre", genreList),
                  _filterBody("Status", statusList),
                  _filterBody("Release Date", decadeList),
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

  Widget _filterBody(String title, DiscoverSheetList sheetList) {
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