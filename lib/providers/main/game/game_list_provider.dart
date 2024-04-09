import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';

class GameListProvider extends BasePaginationProvider<BaseContent> {

  Future<BasePaginationResponse<BaseContent>> getGames({
    int page = 1,
    required String contentTag,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    if (contentTag == Constants.ContentTags[0]) {
      return getList(
        url: "${APIRoutes().gameRoutes.gameBySortFilter}?page=$page&sort=popularity"
      );
    } else if (contentTag == Constants.ContentTags[1]) {
      return getList(
        url: "${APIRoutes().gameRoutes.upcomingGames}?page=$page"
      );
    } else {
      return getList(
        url: "${APIRoutes().gameRoutes.gameBySortFilter}?page=$page&sort=top"
      );
    }
  }

  Future<BasePaginationResponse<BaseContent>> searchGame({
    int page = 1,
    required String search,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().gameRoutes.searchGames}?page=$page&search=$search"
    );
  }

  Future<BasePaginationResponse<BaseContent>> discoverGames({
    int page = 1,
    required String sort,
    bool? tba,
    String? genres,
    String? platform,
    String? publisher,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().gameRoutes.gameBySortFilter}?page=$page&sort=$sort${
        tba != null ? '&tba=$tba' : ''
      }${
        platform != null ? '&platform=${Uri.encodeQueryComponent(platform)}' : ''
      }${
        publisher != null ? '&publisher=${Uri.encodeQueryComponent(publisher)}' : ''
      }${
        genres != null ? '&genres=${Uri.encodeQueryComponent(genres)}' : ''
      }"
    );
  }
}