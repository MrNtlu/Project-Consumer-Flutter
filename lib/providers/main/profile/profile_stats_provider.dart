import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/auth/user_stats.dart';
import 'package:watchlistfy/models/common/backend_request_mapper.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class ProfileStatsProvider with ChangeNotifier {
  BackendRequestMapper interval = Constants.ProfileStatsInterval[0];

  @protected
  UserStats? _item;

  UserStats? get item => _item;

  set setItem(UserStats item) {
    _item = item;
  }

  Future<BaseNullableResponse<UserStats>> getProfileStatistics() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${APIRoutes().userRoutes.statistics}?interval=${interval.request}"),
          headers: UserToken().getBearerToken());

      final decodedResponse =
          await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<UserStats>();
      var data = baseItemResponse.data;

      if (data != null) {
        _item = data;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseNullableResponse(
          message: error.toString(), error: error.toString());
    }
  }
}
