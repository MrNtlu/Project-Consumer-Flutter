import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/utils/type_converter.dart';

class Preview {
  late BasePreviewResponse<BaseContent>? movies;
  final String? error;

  Preview({
    Map<String, dynamic>? movieResponse,
    this.error,
  }) {
    if (movieResponse != null) {
      final typeConverter = TypeConverter<BasePreviewResponse<BaseContent>>();
      movies = typeConverter.convertToObject(movieResponse);
    }
  }
}
