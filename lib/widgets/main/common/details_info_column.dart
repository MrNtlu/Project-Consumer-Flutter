import 'package:flutter/cupertino.dart';

class DetailsInfoColumn extends StatelessWidget {
  final bool shouldShowTitle;
  final String titleOriginal;
  final String length;
  final String releaseDate;

  const DetailsInfoColumn(this.shouldShowTitle, this.titleOriginal, this.length, this.releaseDate, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shouldShowTitle)
            Row(
              children: [
                const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(child: Text(titleOriginal, textAlign: TextAlign.end))
              ],
            ),
          const SizedBox(height: 8,),
          Row(
            children: [
              const Text("Duration", style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(length)
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            children: [
              const Text("Release Date", style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(releaseDate)
            ],
          ),
        ],
      ),
    );
  }
}