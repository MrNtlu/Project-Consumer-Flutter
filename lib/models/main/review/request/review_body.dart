import 'package:watchlistfy/models/common/json_convert.dart';

class ReviewBody extends JSONConverter {
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final bool isSpoiler;
  final int star;
  final String review;

  ReviewBody(
    this.contentID, this.contentExternalID, this.contentExternalIntID,
    this.contentType, this.isSpoiler, this.star, this.review
  );

  @override
  Map<String, Object> convertToJson() => {
    "content_id": contentID,
    if (contentExternalID != null)
    "content_external_id": contentExternalID!,
    if (contentExternalIntID != null)
    "content_external_int_id": contentExternalIntID!,
    "content_type": contentType,
    "is_spoiler": isSpoiler,
    "star": star,
    "review": review
  };
}
