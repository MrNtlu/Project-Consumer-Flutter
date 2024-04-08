import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/models/main/custom-list/request/custom_list_content.dart';

class ReorderCustomList extends JSONConverter {
  final String id;
  final List<CustomListContentBody> content;

  ReorderCustomList(this.id, this.content);

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "content": content.map((e) => e.convertToJson()) 
  };
}
