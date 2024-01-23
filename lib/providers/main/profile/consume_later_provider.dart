import 'dart:convert';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/common/consume_later_response.dart';
import 'package:watchlistfy/providers/common/base_list_provider.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class ConsumeLaterProvider extends BaseProvider<ConsumeLaterResponse> {
  Future<BaseListResponse<ConsumeLaterResponse>> getConsumeLater(
    String? contentType, String sort,
  ) => getList(
    url: "${APIRoutes().userInteractionRoutes.consumeLater}?sort=$sort${contentType != null ? '&type=$contentType' : ''}"
  );

  Future<BaseMessageResponse> deleteConsumeLater(
    String id,
    ConsumeLaterResponse response,
  ) => deleteItem(id, url: APIRoutes().userInteractionRoutes.consumeLater, deleteItem: response);

  Future<BaseMessageResponse> moveToUserList(
    String id, 
    int? score,
    ConsumeLaterResponse deleteItem,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().userInteractionRoutes.moveConsumeLaterAsUserList),
        body: json.encode({
          "id": id,
          if (score != null)
          "score": score
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