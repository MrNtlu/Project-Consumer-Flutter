import 'package:watchlistfy/models/common/json_convert.dart';

class IncrementTVListBody extends JSONConverter {
  final String id;
  final bool isEpisode;

  IncrementTVListBody(this.id, this.isEpisode);

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "is_episode": isEpisode,
  };
}
