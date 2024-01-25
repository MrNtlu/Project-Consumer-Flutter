import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/ai/suggestion_response.dart';
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
        headers: UserToken().getBearerToken()
      );
      
      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseListResponse = decodedResponse.getBaseSuggestion<SuggestionResponse>();
      pitems.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch(error) {
      return BaseSuggestion(error: error.toString());
    }
  }

  Future<BaseSuggestion<SuggestionResponse>> generateRecommendations() async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().openAIRoutes.generateSuggestions),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseListResponse = decodedResponse.getBaseSuggestion<SuggestionResponse>();
      pitems.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch (error) {
      return BaseSuggestion(error: error.toString());
    }
  }
}
