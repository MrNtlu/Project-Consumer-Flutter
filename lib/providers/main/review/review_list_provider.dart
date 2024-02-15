import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class ReviewListProvider extends BasePaginationProvider<Review> {
  String sort = Constants.SortReviewRequests[0].request;

  Future<BasePaginationResponse<Review>> getReviews({
    int page = 1,
    required String contentID,
    String? contentExternalID,
    int? contentExternalIntID,
    required String contentType,
  }) {
    if (page == 1) {
      pitems.clear();
    }
    
    return getList(
      url: "${APIRoutes().reviewRoutes.review}?page=$page&content_id=$contentID&content_type=$contentType&sort=$sort${
        contentExternalID != null ? '&content_external_id=$contentExternalID' : ''
      }${
        contentExternalIntID != null ? '&content_external_int_id=$contentExternalIntID' : ''
      }"
    );
  }

  Future<BaseMessageResponse> deleteReview(
    String id,
    Review deleteItem,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().reviewRoutes.deleteReview),
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

  Future<BaseMessageResponse> voteReview(
    String id,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse(APIRoutes().reviewRoutes.voteReview),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;
      
      var baseItemResponse = decodedResponse.getBaseItemResponse<Review>();
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