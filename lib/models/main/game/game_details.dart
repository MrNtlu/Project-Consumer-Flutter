import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/game/game_play_list.dart';

class GameDetails extends DetailsModel<GamePlayList> {
  @override
  GamePlayList? userList;
  @override
  ConsumeLater? consumeLater;
}