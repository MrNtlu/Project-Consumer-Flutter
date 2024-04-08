import 'package:watchlistfy/models/common/json_convert.dart';

class IDBody extends JSONConverter {
  final String id;
  final String type;

  IDBody(this.id, this.type);

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "type": type,
  };
}