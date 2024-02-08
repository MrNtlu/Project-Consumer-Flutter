import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class CustomListShareProvider with ChangeNotifier {
  bool isLoading = false;

  @protected
  CustomList? _item;

  CustomList? get item => _item;

  set setItem(CustomList item) {
    _item = item;
  }

  Future<BaseNullableResponse<CustomList>> getCustomListDetails({required String id}) async {
    try {
      final response = await http.get(
        Uri.parse("${APIRoutes().customListRoutes.customListDetails}?id=$id"),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<CustomList>();
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