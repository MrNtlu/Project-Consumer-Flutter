import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/models/main/movie/movie_details.dart';
import 'package:watchlistfy/models/main/movie/movie_watch_list.dart';
import 'package:watchlistfy/models/main/movie/movie_watch_list_body.dart';
import 'package:watchlistfy/models/main/movie/movie_watch_list_update_body.dart';
import 'package:watchlistfy/providers/common/base_details_provider.dart';
import 'package:watchlistfy/static/routes.dart';

class MovieDetailsProvider extends BaseDetailsProvider<MovieDetails> {
  Future<BaseNullableResponse<MovieDetails>> getMovieDetails(
    String id,
  ) async =>
      getDetails(
        url: "${APIRoutes().movieRoutes.movieDetails}?id=$id",
      );

  Future<BaseNullableResponse<ConsumeLater>> createConsumeLaterObject(
    ConsumeLaterBody body,
  ) async =>
      createConsumeLater(
        body,
        url: APIRoutes().userInteractionRoutes.consumeLater,
      );

  Future<BaseMessageResponse> deleteConsumeLaterObject(
    IDBody body,
  ) async =>
      deleteConsumeLater(
        body,
        url: APIRoutes().userInteractionRoutes.consumeLater,
      );

  Future<BaseNullableResponse<MovieWatchList>> createMovieWatchList(
    MovieWatchListBody body,
  ) async =>
      createUserList<MovieWatchListBody, MovieWatchList>(
        body,
        url: APIRoutes().userListRoutes.movieUserList,
      );

  Future<BaseNullableResponse<MovieWatchList>> updateMovieWatchList(
    MovieWatchListUpdateBody body,
  ) async =>
      updateUserList<MovieWatchListUpdateBody, MovieWatchList>(
        body,
        url: APIRoutes().userListRoutes.movieUserList,
      );

  Future<BaseMessageResponse> deleteMovieWatchList(
    DeleteUserListBody body,
  ) async =>
      deleteUserList(
        body,
        url: APIRoutes().userListRoutes.deleteUserList,
      );
}
