import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';

class AnimeListProvider extends BasePaginationProvider<BaseContent> {

  Future<BasePaginationResponse<BaseContent>> getAnime({
    int page = 1,
    required String contentTag,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    if (contentTag == Constants.ContentTags[0]) {
      return getList(
        url: "${APIRoutes().animeRoutes.animeBySortFilter}?page=$page&sort=popularity"
      );
    } else if (contentTag == Constants.ContentTags[1]) {
      return getList(
        url: "${APIRoutes().animeRoutes.upcomingAnime}?page=$page"
      );
    } else if (contentTag == Constants.ContentTags[2]) {
      return getList(
        url: "${APIRoutes().animeRoutes.animeBySortFilter}?page=$page&sort=top&status=finished"
      );
    } else {
      return getList(
        url: "${APIRoutes().animeRoutes.airingAnime}?page=$page"
      );
    }
  }
}