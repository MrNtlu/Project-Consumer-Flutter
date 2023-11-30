import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/backend_request_mapper.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/preview_response.dart';
import 'package:watchlistfy/models/main/movie/movie.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/utils/extensions.dart';

class PreviewProvider with ChangeNotifier {
  NetworkState networkState = NetworkState.init;
  BackendRequestMapper selectedContentType = Constants.CONTENT_TYPES[0];
  BasePreviewResponse<Movie> moviePreview = BasePreviewResponse();

  Future<Preview> getPreviews() async {
    networkState = NetworkState.loading;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(APIRoutes().previewRoutes.preview));
      if (response.getPreviewResponse().movies != null) {
        moviePreview = response.getPreviewResponse().movies!;
      }
      networkState = NetworkState.success;
      
      notifyListeners();
      return response.getPreviewResponse();
    } catch (error) {
      networkState = NetworkState.error;
      notifyListeners();
      return Preview(error: error.toString());
    }
  }
}
