import 'dart:convert';

import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/providers/common/base_list_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class CustomListInteractionProvider extends BaseProvider<CustomList> {
  String sort = Constants.SortCustomListRequests[0].request;

  Future<BaseListResponse<CustomList>> getLikedCustomLists() => getList(
    url: '${APIRoutes().customListRoutes.likededCustomLists}?sort=$sort'
  );

  Future<BaseMessageResponse> likeCustomList(
    String id,
    CustomList deleteItem,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse(APIRoutes().customListRoutes.likeCustomList),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseMessageResponse().error == null) {
        pitems.remove(deleteItem);
        notifyListeners();   
      }

      return response.getBaseMessageResponse();
    } catch (error) {
      return BaseMessageResponse(error.toString(), error.toString());
    }
  }

  Future<BaseListResponse<CustomList>> getBookmarkedCustomLists() => getList(
    url: '${APIRoutes().customListRoutes.bookmarkedCustomLists}?sort=$sort'
  );

  Future<BaseMessageResponse> bookmarkCustomList(
    String id,
    CustomList deleteItem,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse(APIRoutes().customListRoutes.bookmarkCustomList),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseMessageResponse().error == null) {
        pitems.remove(deleteItem);
        notifyListeners();   
      }
      
      return response.getBaseMessageResponse();
    } catch (error) {
      return BaseMessageResponse(error.toString(), error.toString());
    }
  }
}