import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class ProfileDisplayDetailsProvider with ChangeNotifier {
  bool isLoading = false;

  @protected
  UserInfo? _item;

  UserInfo? get item => _item;

  set setItem(UserInfo item) {
    _item = item;
  }

  Future<BaseNullableResponse<UserInfo>> getProfileDetails(String username) async {
    try {
      final response = await http.get(
        Uri.parse("${APIRoutes().userRoutes.profileFromUsername}?username=$username"),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<UserInfo>();
      print(decodedResponse);
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
}
