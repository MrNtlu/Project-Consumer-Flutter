import 'package:watchlistfy/models/common/json_convert.dart';

class CustomListContentBody extends JSONConverter {
  final int order;
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;

  CustomListContentBody(
    this.order, this.contentID, this.contentExternalID,
    this.contentExternalIntID, this.contentType,
  );

  @override
  Map<String, Object> convertToJson() => {
    "order": order,
    "content_id": contentID,
    if (contentExternalID != null)
    "content_external_id": contentExternalID!,
    if (contentExternalIntID != null)
    "content_external_int_id": contentExternalIntID!,
    "content_type": contentType,
  };
}