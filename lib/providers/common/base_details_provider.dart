import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class BaseDetailsProvider<T extends DetailsModel> with ChangeNotifier {
  bool isLoading = false;

  @protected
  T? _item;

  T? get item => _item;

  set setItem(T item) {
    _item = item;
  }

  @protected
  Future<BaseNullableResponse<T>> getDetails({required String url}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<T>();
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

  @protected
  Future<BaseNullableResponse<ConsumeLater>> createConsumeLater<Request extends JSONConverter>(
    Request request, {required String url}
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(request.convertToJson()), 
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;
      
      isLoading = false;
      var baseItemResponse = decodedResponse.getBaseItemResponse<ConsumeLater>();
      var data = baseItemResponse.data;

      if (data != null && _item != null) {
        _item!.consumeLater = data;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseNullableResponse(message: error.toString());
    }
  }

  @protected
  Future<BaseMessageResponse> deleteConsumeLater(IDBody body, {required String url}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(url),
        body: json.encode(body.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;
      
      isLoading = false;
      var messageResponse = decodedResponse.getBaseMessageResponse();

      if (messageResponse.error == null) {
        _item!.consumeLater = null;

        notifyListeners();
      }

      return messageResponse;
    } catch (error) {
      return BaseMessageResponse(error.toString(), error.toString());
    }
  }
}