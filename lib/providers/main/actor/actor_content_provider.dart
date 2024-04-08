import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/routes.dart';

class ActorContentProvider extends BasePaginationProvider<BaseContent> {
  Future<BasePaginationResponse<BaseContent>> getContentByActor({
    int page = 1,
    required String id,
    required bool isMovie,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    if (isMovie) {
      return getList(
        url: "${APIRoutes().movieRoutes.moviesByActor}?page=$page&id=$id"
      );
    } else {
      return getList(
        url: "${APIRoutes().tvRoutes.tvSeriesByActor}?page=$page&id=$id"
      );
    }
  }
}
