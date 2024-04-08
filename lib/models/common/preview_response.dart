import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/utils/type_converter.dart';

class Preview {
  late BasePreviewResponse<BaseContent>? movies;
  late BasePreviewResponse<BaseContent>? tvSeries;
  late BasePreviewResponse<BaseContent>? anime;
  late BasePreviewResponse<BaseContent>? games;
  final String? error;

  Preview({
    Map<String, dynamic>? movieResponse,
    Map<String, dynamic>? tvResponse,
    Map<String, dynamic>? animeResponse,
    Map<String, dynamic>? gameResponse,
    this.error,
  }) {
    if (movieResponse != null) {
      final typeConverter = TypeConverter<BasePreviewResponse<BaseContent>>();
      movies = typeConverter.convertToObject(movieResponse);
    }

    if (tvResponse != null) {
      final typeConverter = TypeConverter<BasePreviewResponse<BaseContent>>();
      tvSeries = typeConverter.convertToObject(tvResponse);
    }

    if (animeResponse != null) {
      final typeConverter = TypeConverter<BasePreviewResponse<BaseContent>>();
      anime = typeConverter.convertToObject(animeResponse);
    }

    if (gameResponse != null) {
      final typeConverter = TypeConverter<BasePreviewResponse<BaseContent>>();
      games = typeConverter.convertToObject(gameResponse);
    }
  }
}
