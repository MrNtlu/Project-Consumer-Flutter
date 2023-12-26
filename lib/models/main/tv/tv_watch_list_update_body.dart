import 'package:watchlistfy/models/common/json_convert.dart';

class TVWatchListUpdateBody extends JSONConverter {
  final String id;
  final bool isUpdatingScore;
  final int? score;
  final String status;
  final int? timesFinished;
  final int? watchedEpisodes;
  final int? watchedSeasons;

  TVWatchListUpdateBody(
    this.id, this.isUpdatingScore, this.score,
    this.status, this.timesFinished,
    this.watchedEpisodes, this.watchedSeasons,
  );

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "is_updating_score": isUpdatingScore,
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