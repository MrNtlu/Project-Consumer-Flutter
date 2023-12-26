import 'package:watchlistfy/models/common/json_convert.dart';

class TVWatchListBody extends JSONConverter {
  final String tvID;
  final String tvTMDBId;
  final int? timesFinished;
  final int? score;
  final String status;
  final int? watchedEpisodes;
  final int? watchedSeasons;

  TVWatchListBody(
    this.tvID, this.tvTMDBId, 
    this.timesFinished, this.score, this.status,
    this.watchedEpisodes, this.watchedSeasons,
  );

  @override
  Map<String, Object> convertToJson() => {
    "tv_id": tvID,
    "tv_tmdb_id": tvTMDBId,
    "times_finished": timesFinished ?? 0,
    if (score != null)
    "score": score!,
    "status": status,
    if (watchedEpisodes != null)
    "watched_episodes": watchedEpisodes!,
    if (watchedSeasons != null)
    "watched_seasons": watchedSeasons!,
  };
}