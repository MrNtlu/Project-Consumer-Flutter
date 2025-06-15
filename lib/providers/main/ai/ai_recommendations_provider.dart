import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/ai/suggestion_response.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/request/consume_later_body.dart';
import 'package:watchlistfy/models/main/common/request/id_body.dart';
import 'package:watchlistfy/providers/common/base_list_provider.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class AIRecommendationsProvider extends BaseProvider<SuggestionResponse> {
  Future<BaseSuggestion<SuggestionResponse>> getRecommendations() async {
    try {
      pitems.clear();
      final response = await http.get(
        Uri.parse(APIRoutes().openAIRoutes.suggestions),
        headers: UserToken().getBearerToken(),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      var baseListResponse =
          decodedResponse.getBaseSuggestion<SuggestionResponse>();
      pitems.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch (error) {
      return BaseSuggestion(error: error.toString());
    }
  }

  Future<BaseMessageResponse> markAndUnmarkAsNotInterested(
    String id,
    String contentType,
    bool isDelete,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().openAIRoutes.notInterested),
        headers: UserToken().getBearerToken(),
        body: jsonEncode({
          "content_id": id,
          "content_type": contentType,
          "is_delete": isDelete,
        }),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      return decodedResponse.getBaseMessageResponse();
    } catch (error) {
      return BaseMessageResponse(null, error.toString());
    }
  }

  Future<BaseNullableResponse<ConsumeLater>> createConsumeLaterObject(
      ConsumeLaterBody body) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().userInteractionRoutes.consumeLater),
        headers: UserToken().getBearerToken(),
        body: jsonEncode(body.convertToJson()),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      return decodedResponse.getBaseItemResponse<ConsumeLater>();
    } catch (error) {
      return BaseNullableResponse(message: error.toString());
    }
  }

  Future<BaseMessageResponse> deleteConsumeLaterObject(IDBody body) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().userInteractionRoutes.consumeLater),
        headers: UserToken().getBearerToken(),
        body: jsonEncode(body.convertToJson()),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      return decodedResponse.getBaseMessageResponse();
    } catch (error) {
      return BaseMessageResponse(null, error.toString());
    }
  }

  void updateItemConsumeLater(String id, String contentId, bool isAdded) {
    final index = pitems.indexWhere((item) => item.contentID == contentId);
    if (index != -1) {
      final oldItem = pitems[index];
      // Create a dummy consume later response when added, null when removed
      final newConsumeLater = isAdded
          ? ConsumeLaterSuggestionResponse(
              id,
              "temp_user_id",
              contentId,
              oldItem.contentExternalID,
              oldItem.contentExternalIntID,
              oldItem.contentType,
              DateTime.now().toIso8601String(),
              ConsumeLaterSuggestionContent(
                oldItem.titleEn,
                oldItem.titleOriginal,
                oldItem.imageUrl,
                oldItem.score,
                oldItem.description,
              ),
            )
          : null;

      pitems[index] = SuggestionResponse(
        oldItem.id,
        oldItem.contentID,
        oldItem.contentExternalID,
        oldItem.contentExternalIntID,
        oldItem.contentType,
        oldItem.titleEn,
        oldItem.titleOriginal,
        oldItem.imageUrl,
        oldItem.score,
        oldItem.description,
        newConsumeLater,
        oldItem.isNotInterested,
      );
      notifyListeners();
    }
  }

  void updateItemNotInterested(String contentId, bool isNotInterested) {
    final index = pitems.indexWhere((item) => item.contentID == contentId);
    if (index != -1) {
      final oldItem = pitems[index];
      pitems[index] = SuggestionResponse(
        oldItem.id,
        oldItem.contentID,
        oldItem.contentExternalID,
        oldItem.contentExternalIntID,
        oldItem.contentType,
        oldItem.titleEn,
        oldItem.titleOriginal,
        oldItem.imageUrl,
        oldItem.score,
        oldItem.description,
        oldItem.consumeLater,
        isNotInterested,
      );
      notifyListeners();
    }
  }
}
