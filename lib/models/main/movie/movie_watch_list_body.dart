import 'package:watchlistfy/models/common/json_convert.dart';

class MovieWatchListBody extends JSONConverter {
  final String movieID;
  final String movieTMDBId;
  final int? timesFinished;
  final int? score;
  final String status;

  MovieWatchListBody(
    this.movieID, this.movieTMDBId, 
    this.timesFinished, this.score, this.status
  );

  @override
  Map<String, Object> convertToJson() => {
    "movie_id": movieID,
    "movie_tmdb_id": movieTMDBId,
    "times_finished": timesFinished ?? 0,
    if (score != null)
    "score": score!,
    "status": status
  };
}
