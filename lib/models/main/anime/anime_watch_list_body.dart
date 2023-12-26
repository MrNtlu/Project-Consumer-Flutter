import 'package:watchlistfy/models/common/json_convert.dart';

class AnimeWatchListBody extends JSONConverter {
  final String animeID;
  final String animeMALId;
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
    "tv_id": animeID,
    "tv_tmdb_id": animeMALId,
    "times_finished": timesFinished ?? 0,
    if (score != null)
    "score": score!,
    "status": status,
    if (watchedEpisodes != null)
    "watched_episodes": watchedEpisodes!,
  };
}