import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/recommendation/recommendation.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class RecommendationListProvider extends BasePaginationProvider<RecommendationWithContent> {
  String sort = Constants.SortReviewRequests[0].request;

  Future<BasePaginationResponse<RecommendationWithContent>> getRecommendations({
    int page = 1,
    required String contentID,
    required String contentType,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().recommendationRoutes.recommendationByContent}?page=$page&content_id=$contentID&content_type=$contentType&sort=$sort"
    );
  }

  Future<BaseMessageResponse> deleteRecommendation(
    String id,
    RecommendationWithContent deleteItem,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().recommendationRoutes.deleteRecommendation),
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

  Future<BaseMessageResponse> likeRecommendation(
    String id,
    String contentType,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse(APIRoutes().recommendationRoutes.likeRecommendation),
        body: json.encode({
          "id": id,
          "type": contentType,
        }),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<RecommendationWithContent>();
      var data = baseItemResponse.data;

      if (response.getBaseMessageResponse().error == null && data != null) {
        items[items.indexWhere((element) => element.id == data.id)] = data;
        notifyListeners();
      }

      return response.getBaseMessageResponse();
    } catch (error) {
      return BaseMessageResponse(error.toString(), error.toString());
    }
  }
}