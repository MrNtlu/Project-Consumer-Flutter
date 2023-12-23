import 'package:watchlistfy/models/common/json_convert.dart';

class ConsumeLaterBody extends JSONConverter {
  final String contentID;
  final String contentExternalID;
  final String contentType;

  ConsumeLaterBody(
    this.contentID, this.contentExternalID, this.contentType
  );
  
  @override
  Map<String, Object> convertToJson() => {
    "content_id": contentID,
    "content_external_id": contentExternalID,
    "content_type": contentType
  };
}
