import 'package:flutter/cupertino.dart';

class GameDetailsInfoColumn extends StatelessWidget {
  final bool shouldShowTitle;
  final String titleOriginal;
  final String? ageRating;
  final int? metacriticScore;

  const GameDetailsInfoColumn(
    this.shouldShowTitle, this.titleOriginal, this.ageRating, this.metacriticScore, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Column(
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
        //Age Rating
        if(ageRating != null)
        Row(
          children: [
            const Text("Age Rating", style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(ageRating!)
          ],
        ),
        const SizedBox(height: 8),
        //Metacritic
        if(metacriticScore != null)
        Row(
          children: [
            const Text("Metacritic", style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(metacriticScore.toString())
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
