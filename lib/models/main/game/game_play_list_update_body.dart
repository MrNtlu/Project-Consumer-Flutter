
import 'package:watchlistfy/models/common/json_convert.dart';

class GamePlayListUpdateBody extends JSONConverter {
  final String id;
  final bool isUpdatingScore;
  final int? score;
  final String status;
  final int? timesFinished;
  final int? hoursPlayed;

  GamePlayListUpdateBody(
    this.id, this.isUpdatingScore, this.score,
    this.status, this.timesFinished, this.hoursPlayed
  );

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "is_updating_score": isUpdatingScore,
    "times_finished": timesFinished ?? 0,
    if (score != null)
    "score": score!,
    "status": status,
    if (hoursPlayed != null)
    "hours_played": hoursPlayed!,
  };
}