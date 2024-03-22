import 'package:watchlistfy/models/common/json_convert.dart';

class RecommendationBody extends JSONConverter {
  final String contentID;
  final String recommendationID;
  final String contentType;
  final String? reason;

  RecommendationBody(
    this.contentID, this.recommendationID,
    this.contentType, this.reason
  );

  @override
  Map<String, Object> convertToJson() => {
    "content_id": contentID,
    "recommendation_id": recommendationID,
    "content_type": contentType,
    if (reason != null)
    "review": reason!
  };
}