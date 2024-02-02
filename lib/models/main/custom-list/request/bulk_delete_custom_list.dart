import 'package:watchlistfy/models/common/json_convert.dart';

class BulkDeleteCustomListBody extends JSONConverter {
  final String id;
  final List<String> content;

  BulkDeleteCustomListBody(this.id, this.content);

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "content": content,
  };
}
