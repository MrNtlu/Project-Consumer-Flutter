import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/movie/movie.dart';
import 'package:watchlistfy/utils/type_converter.dart';

class Preview {
  late BasePreviewResponse<Movie>? movies;
  final String? error;

  Preview({
    Map<String, dynamic>? movieResponse,
    this.error,
  }) {
    if (movieResponse != null) {
      final typeConverter = TypeConverter<BasePreviewResponse<Movie>>();
      movies = typeConverter.convertToObject(movieResponse);
    }
  }
}
