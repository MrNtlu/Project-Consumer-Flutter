import 'package:watchlistfy/models/common/json_convert.dart';

class GamePlayListBody extends JSONConverter {
  final String gameID;
  final int gameRAWGId;
  final int? timesFinished;
  final int? score;
  final String status;
  final int? hoursPlayed;

  GamePlayListBody(
    this.gameID, this.gameRAWGId, this.timesFinished,
    this.score, this.status, this.hoursPlayed,
  );

  @override
  Map<String, Object> convertToJson() => {
    "game_id": gameID,
    "game_rawg_id": gameRAWGId,
    "times_finished": timesFinished ?? 0,
    if (score != null)
    "score": score!,
    "status": status,
    if (hoursPlayed != null)
    "hours_played": hoursPlayed!,
  };
}