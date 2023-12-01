import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/common/preview_response.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/utils/extensions.dart';

class PreviewProvider with ChangeNotifier {
  NetworkState networkState = NetworkState.init;
  ContentType selectedContentType = ContentType.movie;
  BasePreviewResponse<BaseContent> moviePreview = BasePreviewResponse();

  Future<Preview> getPreviews() async {
    networkState = NetworkState.loading;

    try {
      final response = await http.get(Uri.parse(APIRoutes().previewRoutes.preview));
      print("Called ${response.getPreviewResponse().movies}");
      if (response.getPreviewResponse().movies != null) {
        moviePreview = response.getPreviewResponse().movies!;
      }
      networkState = NetworkState.success;
      
      notifyListeners();
      return response.getPreviewResponse();
    } catch (error) {
      print("Preview $error");
      networkState = NetworkState.error;
      notifyListeners();
      return Preview(error: error.toString());
    }
  }
}
