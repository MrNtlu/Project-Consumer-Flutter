import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/models/main/social/social.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class SocialProvider with ChangeNotifier {
  NetworkState networkState = NetworkState.init;

  @protected
  Social? _item;

  Social? get item => _item;

  set setItem(Social item) {
    _item = item;
  }

  Future<BaseNullableResponse<Social>> getSocial() async {
    networkState = NetworkState.loading;

    try {
      final response = await http.get(
        Uri.parse(APIRoutes().socialRoutes.social),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<Social>();
      var data = baseItemResponse.data;

      if (data != null) {
        _item = data;
      }

      networkState = NetworkState.success;
      notifyListeners();
      return baseItemResponse;
    } catch (error) {
      networkState = NetworkState.error;
      notifyListeners();
      return BaseNullableResponse(message: error.toString(), error: error.toString());
    }
  }

  Future<BaseMessageResponse> likeReview(
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

      if (response.getBaseMessageResponse().error == null && data != null && _item != null) {
        final changedItem = _item!.reviews[_item!.reviews.indexWhere((element) => element.id == data.id)];
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
