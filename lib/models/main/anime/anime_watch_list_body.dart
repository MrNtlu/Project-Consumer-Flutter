import 'package:watchlistfy/models/common/json_convert.dart';

class AnimeWatchListBody extends JSONConverter {
  final String animeID;
  final int animeMALId;
  final int? timesFinished;
  final int? score;
  final String status;
  final int? watchedEpisodes;

  AnimeWatchListBody(
    this.animeID, this.animeMALId, this.timesFinished, 
    this.score, this.status,this.watchedEpisodes
  );

  @override
  Map<String, Object> convertToJson() => {
    "anime_id": animeID,
    "anime_mal_id": animeMALId,
    if (score != null)
    "score": score!,
    "status": status,
    "times_finished": timesFinished ?? 0,
    if (watchedEpisodes != null)
    "watched_episodes": watchedEpisodes!,
  };
}