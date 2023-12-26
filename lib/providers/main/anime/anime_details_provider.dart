import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/anime/anime_details.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list_body.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list_update_body.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/providers/common/base_details_provider.dart';
import 'package:watchlistfy/static/routes.dart';

class AnimeDetailsProvider extends BaseDetailsProvider<AnimeDetails> {

  Future<BaseNullableResponse<AnimeDetails>> getAnimeDetails(String id) async 
    => getDetails(url: "${APIRoutes().animeRoutes.animeDetails}?id=$id");

  Future<BaseNullableResponse<ConsumeLater>> createConsumeLaterObject(ConsumeLaterBody body) async
    => createConsumeLater(body, url: APIRoutes().userInteractionRoutes.consumeLater);

  Future<BaseMessageResponse> deleteConsumeLaterObject(IDBody body) async
    => deleteConsumeLater(body, url: APIRoutes().userInteractionRoutes.consumeLater);

  Future<BaseNullableResponse<AnimeWatchList>> createAnimeWatchList(AnimeWatchListBody body) async
    => createUserList<AnimeWatchListBody, AnimeWatchList>(body, url: APIRoutes().userListRoutes.animeUserList);

  Future<BaseNullableResponse<AnimeWatchList>> updateAnimeWatchList(AnimeWatchListUpdateBody body) async
    => updateUserList<AnimeWatchListUpdateBody, AnimeWatchList>(body, url: APIRoutes().userListRoutes.animeUserList);

  Future<BaseMessageResponse> deleteAnimeWatchList(DeleteUserListBody body) async
    => deleteUserList(body, url: APIRoutes().userListRoutes.deleteUserList);
}