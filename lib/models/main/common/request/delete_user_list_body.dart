import 'package:watchlistfy/models/common/json_convert.dart';

class DeleteUserListBody extends JSONConverter {
  final String id;
  final String type;

  DeleteUserListBody(this.id, this.type);

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "type": type,
  };
}