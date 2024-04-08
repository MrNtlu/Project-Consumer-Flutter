import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class BaseProvider<T> with ChangeNotifier {
  @protected
  final List<T> pitems = [];

  List<T> get items => pitems;

  @protected
  Future<BaseListResponse<T>> getList<R>({required String url}) async {
    try {
      pitems.clear();
      final response = await http.get(
        Uri.parse(url),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseListResponse = decodedResponse.getBaseListResponse<T>();
      pitems.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch(error) {
      return BaseListResponse(error: error.toString());
    }
  }

  @protected
  Future<BaseNullableResponse<T>> addItem<C extends JSONConverter>(C createObject, {required String url}) async {
    try {
      final encodedRequest = await compute(json.encode, createObject.convertToJson());

      final response = await http.post(
        Uri.parse(url),
        body: encodedRequest,
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<T>();
      var data = baseItemResponse.data;

      if (baseItemResponse.error == null && data != null) {
        pitems.add(data);
        notifyListeners();
      }

      return baseItemResponse;
    } catch(error) {
      return BaseNullableResponse(error: error.toString(), message: error.toString());
    }
  }

  @protected
  Future<BaseMessageResponse> deleteItem(String id, {
    required String url,
    required T deleteItem
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
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