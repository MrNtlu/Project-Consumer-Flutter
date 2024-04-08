import 'dart:convert';

import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class CustomListSocialProvider extends BasePaginationProvider<CustomList> {
  String sort = Constants.SortCustomListRequests[0].request;

  Future<BasePaginationResponse<CustomList>> getCustomList({
    int page = 1,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().customListRoutes.customListSocial}?page=$page&sort=$sort"
    );
  }

  Future<BaseMessageResponse> deleteCustomList(
    String id,
    CustomList deleteItem
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().customListRoutes.deleteCustomList),
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