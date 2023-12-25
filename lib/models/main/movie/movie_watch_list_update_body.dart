import 'package:watchlistfy/models/common/json_convert.dart';

class MovieWatchListUpdateBody extends JSONConverter {
  final String id;
  final bool isUpdatingScore;
  final int? score;
  final String status;
  final int? timesFinished;

  MovieWatchListUpdateBody(
    this.id, this.isUpdatingScore, this.score,
    this.status, this.timesFinished
  );

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "is_updating_score": isUpdatingScore,
    if (score != null)
    "score": score!,
    "status": status,
    "times_finished": timesFinished ?? 0,
  };
}