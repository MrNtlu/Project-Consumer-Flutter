import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/models/main/userlist/user_list.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class UserListProvider with ChangeNotifier {
  bool isLoading = false;

  @protected
  UserList? _item;

  UserList? get item => _item;

  set setItem(UserList item) {
    _item = item;
  }

  Future<BaseNullableResponse<UserList>> getUserList({required String sort}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${APIRoutes().userListRoutes.userList}?sort=$sort"),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      isLoading = false;
      var baseItemResponse = decodedResponse.getBaseItemResponse<UserList>();
      var data = baseItemResponse.data;

      if (data != null) {
        _item = data;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseNullableResponse(message: error.toString(), error: error.toString());
    }
  }

  Future<BaseNullableResponse<UserListContent>> incrementUserList<Request extends JSONConverter>(
    int index, Request request, ContentType type
  ) async {
    late String url;
    late UserListContent? content;

    switch (type) {
      case ContentType.tv:
        url = APIRoutes().userListRoutes.tvIncrement;
        content = item?.tvList[index];
        break;
      case ContentType.anime:
        url = APIRoutes().userListRoutes.animeIncrement;
        content = item?.animeList[index];
        break;
      case ContentType.game:
        url = APIRoutes().userListRoutes.gameIncrement;
        content = item?.gameList[index];
        break;
      default:
        url = APIRoutes().userListRoutes.tvIncrement;
        content = item?.tvList[index];
        break;
    }

    content?.isLoading = true;
    notifyListeners();

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(request.convertToJson()), 
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;
      
      var baseItemResponse = decodedResponse.getBaseItemResponse<UserListContent>();
      var data = baseItemResponse.data;

      content?.isLoading = false;
      if (data != null) {
        content?.changeUserList(data.score, data.timesFinished, data.watchedEpisodes, data.watchedSeasons);
        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      content?.isLoading = false;
      notifyListeners();

      return BaseNullableResponse(message: error.toString());
    }
  }

  Future<BaseNullableResponse<UserListContent>> updateUserList<Request extends JSONConverter>(
    int index, Request request, ContentType type
  ) async {
    isLoading = true;
    notifyListeners();

    late String url;

    switch (type) {
      case ContentType.movie:
        url = APIRoutes().userListRoutes.movieUserList;
        break;
      case ContentType.tv:
        url = APIRoutes().userListRoutes.tvUserList;
        break;
      case ContentType.anime:
        url = APIRoutes().userListRoutes.animeUserList;
        break;
      case ContentType.game:
        url = APIRoutes().userListRoutes.gameUserList;
        break;
    }

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(request.convertToJson()), 
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;
      
      var baseItemResponse = decodedResponse.getBaseItemResponse<UserListContent>();
      var data = baseItemResponse.data;
      
      isLoading = false;
      if (data != null) {
        switch (type) {
          case ContentType.tv:
            item?.tvList[index].changeUserList(data.score, data.timesFinished, data.watchedEpisodes, data.watchedSeasons);
            break;
          case ContentType.anime:
            item?.animeList[index].changeUserList(data.score, data.timesFinished, data.watchedEpisodes, data.watchedSeasons);
            break;
          case ContentType.game:
            item?.gameList[index].changeUserList(data.score, data.timesFinished, data.watchedEpisodes, data.watchedSeasons);
            break;
          default:
            item?.tvList[index].changeUserList(data.score, data.timesFinished, data.watchedEpisodes, data.watchedSeasons);
            break;
        }
        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      isLoading = false;
      notifyListeners();

      return BaseNullableResponse(message: error.toString());
    }
  }

  Future<BaseMessageResponse> deleteUserList(int index, DeleteUserListBody body) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().userListRoutes.deleteUserList),
        body: json.encode(body.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;
      
      isLoading = false;
      var messageResponse = decodedResponse.getBaseMessageResponse();

      if (messageResponse.error == null) {
        if (body.type == ContentType.movie.request) {
          _item?.movieList.removeAt(index);
        } else if (body.type == ContentType.tv.request) {
          _item?.tvList.removeAt(index);
        } else if (body.type == ContentType.anime.request) {
          _item?.animeList.removeAt(index);
        } else if (body.type == ContentType.game.request) {
          _item?.gameList.removeAt(index);
        }
      }
      notifyListeners();

      return messageResponse;
    } catch (error) {
      isLoading = false;
      notifyListeners();

      return BaseMessageResponse(error.toString(), error.toString());
    }
  }
}
