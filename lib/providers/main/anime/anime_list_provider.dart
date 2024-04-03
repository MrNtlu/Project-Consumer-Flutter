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
        url: "${APIRoutes().animeRoutes.popularAnime}?page=$page"
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

  Future<BasePaginationResponse<BaseContent>> searchAnime({
    int page = 1,
    required String search,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().animeRoutes.searchAnime}?page=$page&search=$search"
    );
  }

  Future<BasePaginationResponse<BaseContent>> discoverAnime({
    int page = 1,
    required String sort,
    String? status,
    String? genres,
    String? demographics,
    String? themes,
    String? studios,
    String? season,
    int? year,
    String? streaming,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().animeRoutes.animeBySortFilter}?page=$page&sort=$sort${
        status != null ? '&status=$status' : ''
      }${
        genres != null ? '&genres=$genres' : ''
      }${
        demographics != null ? '&demographics=$demographics' : ''
      }${
        themes != null ? '&themes=$themes' : ''
      }${
        streaming != null ? '&streaming_platforms=${Uri.encodeComponent(streaming)}' : ''
      }${
        studios != null ? '&studios=$studios' : ''
      }${
        season != null ? '&season=$season' : ''
      }${
        year != null ? '&year=$year' : ''
      }"
    );
  }
}