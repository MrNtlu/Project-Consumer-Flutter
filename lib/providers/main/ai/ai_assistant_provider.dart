import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/providers/common/base_list_provider.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

class AIAssistantProvider extends BaseProvider<AIAssistantResponse> {
  Future<BaseAIResponse> getOpinion(String title, String contentType) async {
    try {
      pitems.add(AIAssistantResponse("What is general opinion about it?", false));

      final response = await http.get(
        Uri.parse("${APIRoutes().openAIRoutes.opinion}?content_name=$title&content_type=$contentType"),
        headers: UserToken().getBearerToken()
      );

      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getAIResponse();
      final aiResponse = AIAssistantResponse(baseItemResponse.data.isNotEmpty ? baseItemResponse.data : baseItemResponse.message ?? baseItemResponse.error ?? '', true);
      pitems.add(aiResponse);
      notifyListeners();

      return BaseAIResponse(data: baseItemResponse.data, message: baseItemResponse.message);
    } catch(error) {
      return BaseAIResponse(data: error.toString(), message: error.toString(), error: error.toString());
    }
  }

  Future<BaseAIResponse> getSummarize(String title, String contentType) async {
    try {
      pitems.add(AIAssistantResponse("Summarize the content.", false));
      notifyListeners();

      final response = await http.get(
        Uri.parse("${APIRoutes().openAIRoutes.summary}?content_name=$title&content_type=$contentType"),
        headers: UserToken().getBearerToken()
      );
      
      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getAIResponse();

      final aiResponse = AIAssistantResponse(baseItemResponse.data.isNotEmpty ? baseItemResponse.data : baseItemResponse.message ?? baseItemResponse.error ?? '', true);
      pitems.add(aiResponse);
      notifyListeners();

      return BaseAIResponse(data: baseItemResponse.data, message: baseItemResponse.message);
    } catch(error) {
      return BaseAIResponse(data: error.toString(), message: error.toString(), error: error.toString());
    }
  }
}

class AIAssistantResponse {
  String message;
  bool isAIResponse;

  AIAssistantResponse(this.message, this.isAIResponse);
}
