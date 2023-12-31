import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/models/main/game/game_details.dart';
import 'package:watchlistfy/models/main/game/game_play_list.dart';
import 'package:watchlistfy/models/main/game/game_play_list_body.dart';
import 'package:watchlistfy/models/main/game/game_play_list_update_body.dart';
import 'package:watchlistfy/providers/common/base_details_provider.dart';
import 'package:watchlistfy/static/routes.dart';

class GameDetailsProvider extends BaseDetailsProvider<GameDetails> {
  Future<BaseNullableResponse<GameDetails>> getGameDetails(String id) async 
    => getDetails(url: "${APIRoutes().gameRoutes.gameDetails}?id=$id");

  Future<BaseNullableResponse<ConsumeLater>> createConsumeLaterObject(ConsumeLaterBody body) async
    => createConsumeLater(body, url: APIRoutes().userInteractionRoutes.consumeLater);

  Future<BaseMessageResponse> deleteConsumeLaterObject(IDBody body) async
    => deleteConsumeLater(body, url: APIRoutes().userInteractionRoutes.consumeLater);

  Future<BaseNullableResponse<GamePlayList>> createGamePlayList(GamePlayListBody body) async
    => createUserList<GamePlayListBody, GamePlayList>(body, url: APIRoutes().userListRoutes.gameUserList);

  Future<BaseNullableResponse<GamePlayList>> updateGamePlayList(GamePlayListUpdateBody body) async
    => updateUserList<GamePlayListUpdateBody, GamePlayList>(body, url: APIRoutes().userListRoutes.gameUserList);

  Future<BaseMessageResponse> deleteGamePlayList(DeleteUserListBody body) async
    => deleteUserList(body, url: APIRoutes().userListRoutes.deleteUserList);
}