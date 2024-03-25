import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/recommendation/recommendation.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class RecommendationSocialListProvider extends BasePaginationProvider<RecommendationWithContent> {
  String sort = Constants.SortReviewRequests[0].request;

  Future<BasePaginationResponse<RecommendationWithContent>> getRecommendations({
    int page = 1,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().recommendationRoutes.recommendationListSocial}?page=$page&sort=$sort"
    );
  }

  Future<BaseMessageResponse> likeRecommendation(
    String id,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse(APIRoutes().recommendationRoutes.likeRecommendation),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<RecommendationWithContent>();
      var data = baseItemResponse.data;

      if (response.getBaseMessageResponse().error == null && data != null) {
        final changedItem = pitems[pitems.indexWhere((element) => element.id == data.id)];
        changedItem.likes.clear();
        changedItem.likes.addAll(data.likes);
        changedItem.popularity = data.popularity;
        changedItem.isLiked = data.isLiked;
        notifyListeners();
      }

      return response.getBaseMessageResponse();
    } catch (error) {
      return BaseMessageResponse(error.toString(), error.toString());
    }
  }
}