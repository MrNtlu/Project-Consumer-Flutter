import 'package:flutter/cupertino.dart';

class DetailsInfoColumn extends StatelessWidget {
  final bool shouldShowTitle;
  final String titleOriginal;
  final String? length;
  final int? episodeCount;
  final int? seasonsCount;
  final String releaseDate;

  const DetailsInfoColumn(
    this.shouldShowTitle, this.titleOriginal, this.length, 
    this.releaseDate, this.episodeCount, this.seasonsCount,
    {super.key}
  );

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
          const SizedBox(height: 8),
          //Length
          if (length != null)
          Row(
            children: [
              const Text("Duration", style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(length!)
            ],
          ),
          if (length != null)
          const SizedBox(height: 8),
          //Season Count
          if (seasonsCount != null)
          Row(
            children: [
              const Text("Seasons", style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(seasonsCount!.toString())
            ],
          ),
          if (seasonsCount != null)
          const SizedBox(height: 8),
          //Episode Count
          if (episodeCount != null)
          Row(
            children: [
              const Text("Episodes", style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(episodeCount!.toString())
            ],
          ),
          if (episodeCount != null)
          const SizedBox(height: 8),
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