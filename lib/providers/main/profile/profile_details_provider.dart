import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/models/main/common/request/id_body.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class ProfileDetailsProvider with ChangeNotifier {
  bool isLoading = false;

  @protected
  UserInfo? _item;

  UserInfo? get item => _item;

  set setItem(UserInfo item) {
    _item = item;
  }

  Future<BaseNullableResponse<UserInfo>> getProfileDetails() async {
    try {
      final response = await http.get(Uri.parse(APIRoutes().userRoutes.info),
          headers: UserToken().getBearerToken());

      final decodedResponse =
          await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<UserInfo>();
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

  Future<BaseMessageResponse> deleteConsumeLater(int index, IDBody body) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
          Uri.parse(APIRoutes().userInteractionRoutes.consumeLater),
          body: json.encode(body.convertToJson()),
          headers: UserToken().getBearerToken());

      final decodedResponse =
          await compute(jsonDecode, response.body) as Map<String, dynamic>;

      isLoading = false;
      var messageResponse = decodedResponse.getBaseMessageResponse();

      if (messageResponse.error == null) {
        _item?.watchLater.removeAt(index);
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
