import 'dart:convert';

import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class ReviewUserListProvider extends BasePaginationProvider<ReviewWithContent> {
  String sort = Constants.SortReviewRequests[0].request;

  Future<BasePaginationResponse<ReviewWithContent>> getReviews({
    int page = 1,
  }) {
    if (page == 1) {
      pitems.clear();
    }
    
    return getList(
      url: "${APIRoutes().reviewRoutes.getSelfReviews}?page=$page&sort=$sort",
    );
  }

  Future<BaseMessageResponse> deleteReview(
    String id,
    ReviewWithContent deleteItem,
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
}