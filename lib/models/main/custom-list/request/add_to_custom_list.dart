import 'package:watchlistfy/models/common/json_convert.dart';

class AddToCustomList extends JSONConverter {
  final String id;
  final AddToCustomListContentBody content;

  AddToCustomList(this.id, this.content);

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "content": content.convertToJson(),
  };
}

class AddToCustomListContentBody extends JSONConverter {
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;

  AddToCustomListContentBody(
    this.contentID,
    this.contentExternalID,
    this.contentExternalIntID,
    this.contentType,
  );

  @override
  Map<String, Object> convertToJson() => {
    "content_id": contentID,
    if (contentExternalID != null)
      "content_external_id": contentExternalID!,
    if (contentExternalIntID != null)
      "content_external_int_id": contentExternalIntID!,
    "content_type": contentType,
  };
}
