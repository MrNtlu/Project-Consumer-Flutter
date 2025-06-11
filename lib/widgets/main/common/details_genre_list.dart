import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

class DetailsGenreList extends StatelessWidget {
  final List<String> list;
  final Function(String) returnPage;

  const DetailsGenreList(this.list, this.returnPage, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final appColors = AppColors();

    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final data = list[index];

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 3, right: 3),
            child: CupertinoChip(
              isSelected: false,
              shouldShowBorder: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              selectedBGColor: cupertinoTheme.profileButton,
              selectedTextColor: appColors.primaryColor,
              label: data,
              onSelected: (_) => _navigateToGenrePage(context, data),
            ),
          );
        },
      ),
    );
  }

  void _navigateToGenrePage(BuildContext context, String genre) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(builder: (_) => returnPage(genre)),
    );
  }
}
