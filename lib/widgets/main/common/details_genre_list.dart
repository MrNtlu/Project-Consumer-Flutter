import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

class DetailsGenreList extends StatelessWidget {
  final List<String> list;
  final Function(String) returnPage;

  const DetailsGenreList(this.list, this.returnPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final data = list[index];

          return CupertinoChip(
            isSelected: false,
            label: data,
            onSelected: (_) {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) {
                  return returnPage(Uri.encodeQueryComponent(data));
                })
              );
            }
          );
        }
      ),
    );
  }
}