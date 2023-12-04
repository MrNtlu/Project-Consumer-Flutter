import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/preview_response.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/utils/extensions.dart';

class PreviewProvider with ChangeNotifier {
  NetworkState networkState = NetworkState.init;
  
  BasePreviewResponse<BaseContent> moviePreview = BasePreviewResponse();
  BasePreviewResponse<BaseContent> tvPreview = BasePreviewResponse();
  BasePreviewResponse<BaseContent> animePreview = BasePreviewResponse();
  BasePreviewResponse<BaseContent> gamePreview = BasePreviewResponse();

  Future<Preview> getPreviews() async {
    networkState = NetworkState.loading;

    try {
      final response = await http.get(Uri.parse(APIRoutes().previewRoutes.preview));
      final decodedResponse = await compute(jsonDecode, response.body) as Map<String, dynamic>;
      final previewResponse = decodedResponse.getPreviewResponse();

      if (previewResponse.movies != null) {
        moviePreview = previewResponse.movies!;
      }

      if (previewResponse.tvSeries != null) {
        tvPreview = previewResponse.tvSeries!;
      }

      if (previewResponse.anime != null) {
        animePreview = previewResponse.anime!;
      }

      if (previewResponse.games != null) {
        gamePreview = previewResponse.games!;
      }
      networkState = NetworkState.success;
      
      notifyListeners();
      return previewResponse;
    } catch (error) {
      networkState = NetworkState.error;
      notifyListeners();
      return Preview(error: error.toString());
    }
  }
}
