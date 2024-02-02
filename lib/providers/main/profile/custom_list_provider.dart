import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/providers/common/base_list_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';

class CustomListProvider extends BaseProvider<CustomList> {
  String sort = Constants.SortCustomListRequests[0].request;

  Future<BaseListResponse<CustomList>> getCustomLists({
    String? userId,
  }) => getList(
    url: "${APIRoutes().customListRoutes.customLists}?sort=$sort${userId != null ? '&user_id=$userId' : ''}"
  );
}