import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/models/main/custom-list/request/custom_list_content.dart';

class CreateCustomList extends JSONConverter {
  final String name;
  final String? description;
  final bool isPrivate;
  final List<CustomListContentBody> content;

  CreateCustomList(this.name, this.description, this.isPrivate, this.content);

  @override
  Map<String, Object> convertToJson() => {
    "name": name,
    if (description != null)
    "description": description!,
    "is_private": isPrivate,
    "content": content.map((e) => e.convertToJson()) 
  };
}
