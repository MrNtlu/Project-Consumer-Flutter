import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class BasePaginationProvider<T> with ChangeNotifier {
  @protected
  final List<T> pitems = [];

  List<T> get items => pitems;

  @protected
  Future<BasePaginationResponse<T>> getList({required String url}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: UserToken().getBearerToken()
      );

      //TODO implement with factory
      var basePaginationResponse = response.getBasePaginationResponse<T>();
      pitems.addAll(basePaginationResponse.data);
      notifyListeners();


      return basePaginationResponse;
    } catch(error) {
      return BasePaginationResponse(error: error.toString(), canNextPage: false);
    }
  }
}