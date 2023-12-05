import 'package:watchlistfy/models/common/json_convert.dart';

class IDBody extends JSONConverter {
  final String id;

  IDBody(this.id);
  @override
  Map<String, Object> convertToJson() => {
    "id": id,
  };


}
