import 'package:watchlistfy/models/common/json_convert.dart';

class UpdateReviewBody extends JSONConverter {
  final String id;
  final bool isSpoiler;
  final int star;
  final String review;

  UpdateReviewBody(
    this.id, this.isSpoiler, this.star, this.review
  );

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "is_spoiler": isSpoiler,
    "star": star,
    "review": review
  };
}