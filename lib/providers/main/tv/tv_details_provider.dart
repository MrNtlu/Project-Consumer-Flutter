import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/models/main/tv/tv_details.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list_body.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list_update_body.dart';
import 'package:watchlistfy/providers/common/base_details_provider.dart';
import 'package:watchlistfy/static/routes.dart';

class TVDetailsProvider extends BaseDetailsProvider<TVDetails> {
  @override
  Future<void> fetchData(String id) async {
    await getTVDetails(id);
  }

  Future<BaseNullableResponse<TVDetails>> getTVDetails(String id) async =>
      getDetails(url: "${APIRoutes().tvRoutes.tvSeriesDetails}?id=$id");

  Future<BaseNullableResponse<ConsumeLater>> createConsumeLaterObject(
          ConsumeLaterBody body) async =>
      createConsumeLater(body,
          url: APIRoutes().userInteractionRoutes.consumeLater);

  Future<BaseMessageResponse> deleteConsumeLaterObject(IDBody body) async =>
      deleteConsumeLater(body,
          url: APIRoutes().userInteractionRoutes.consumeLater);

  Future<BaseNullableResponse<TVWatchList>> createTVWatchList(
          TVWatchListBody body) async =>
      createUserList<TVWatchListBody, TVWatchList>(body,
          url: APIRoutes().userListRoutes.tvUserList);

  Future<BaseNullableResponse<TVWatchList>> updateTVWatchList(
          TVWatchListUpdateBody body) async =>
      updateUserList<TVWatchListUpdateBody, TVWatchList>(body,
          url: APIRoutes().userListRoutes.tvUserList);

  Future<BaseMessageResponse> deleteTVWatchList(
          DeleteUserListBody body) async =>
      deleteUserList(body, url: APIRoutes().userListRoutes.deleteUserList);
}
