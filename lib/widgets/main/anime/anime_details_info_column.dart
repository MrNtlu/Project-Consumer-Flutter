import 'package:flutter/cupertino.dart';

class AnimeDetailsInfoColumn extends StatelessWidget {
  final String titleOriginal;
  final String titleJP;
  final String season;
  final String episodes;
  final String releaseDate;
  final String source;
  final String type;

  const AnimeDetailsInfoColumn(
    this.titleOriginal,
    this.titleJP,
    this.season,
    this.episodes,
    this.releaseDate,
    this.source,
    this.type,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            Expanded(child: Text(titleOriginal, textAlign: TextAlign.end))
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                titleJP, 
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
              )
            ),
          ],
        ),
        const SizedBox(height: 8),
        //Release Date
        Row(
          children: [
            const Text("Aired", style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(releaseDate)
          ],
        ),
        const SizedBox(height: 8),
        //Season
        Row(
          children: [
            const Text("Season", style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(season)
          ],
        ),
        const SizedBox(height: 8),
        //Episodes
        Row(
          children: [
            const Text("Episodes", style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(episodes)
          ],
        ),
        const SizedBox(height: 8),
        //Source
        Row(
          children: [
            const Text("Source", style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(source)
          ],
        ),
        const SizedBox(height: 8),
        //Type
        Row(
          children: [
            const Text("Type", style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(type)
          ],
        ),
      ],
    );
  }
}