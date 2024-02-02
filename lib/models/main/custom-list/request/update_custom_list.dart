import 'package:watchlistfy/models/common/json_convert.dart';

class UpdateCustomListBody extends JSONConverter {
  final String id;
  final String name;
  final String? description;
  final bool isPrivate;

  UpdateCustomListBody(
    this.id, this.name, this.description, this.isPrivate
  );

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "name": name,
    if (description != null)
    "description": description!,
    "is_private": isPrivate,
  };
}
