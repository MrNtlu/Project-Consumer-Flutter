import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/models/main/custom-list/request/custom_list_content.dart';

class UpdateCustomListBody extends JSONConverter {
  final String id;
  final String name;
  final String? description;
  final bool isPrivate;
  final List<CustomListContentBody> content;

  UpdateCustomListBody(
    this.id, this.name, this.description, 
    this.isPrivate, this.content
  );

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "name": name,
    if (description != null)
    "description": description!,
    "is_private": isPrivate,
    "content": content.map((e) => e.convertToJson()).toList()
  };
}
