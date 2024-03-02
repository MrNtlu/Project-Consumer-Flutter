import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';

class MovieListProvider extends BasePaginationProvider<BaseContent> {

  Future<BasePaginationResponse<BaseContent>> getMovies({
    int page = 1,
    required String contentTag,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    if (contentTag == Constants.ContentTags[0]) {
      return getList(
        url: "${APIRoutes().movieRoutes.movieBySortFilter}?page=$page&sort=popularity"
      );
    } else if (contentTag == Constants.ContentTags[1]) {
      return getList(
        url: "${APIRoutes().movieRoutes.upcomingMovies}?page=$page"
      );
    } else if (contentTag == Constants.ContentTags[2]) {
      return getList(
        url: "${APIRoutes().movieRoutes.movieBySortFilter}?page=$page&sort=top&status=released"
      );
    } else {
      return getList(
        url: "${APIRoutes().movieRoutes.theaterMovies}?page=$page"
      );
    }
  }

  Future<BasePaginationResponse<BaseContent>> searchMovie({
    int page = 1,
    required String search,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().movieRoutes.searchMovies}?page=$page&search=$search"
    );
  }

  Future<BasePaginationResponse<BaseContent>> discoverMovies({
    int page = 1,
    required String sort,
    String? status,
    String? productionCompany,
    String? genres,
    int? from,
    int? to,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().movieRoutes.movieBySortFilter}?page=$page&sort=$sort${
        status != null ? '&status=$status' : ''
      }${
        productionCompany != null ? '&production_companies=$productionCompany' : ''
      }${
        genres != null ? '&genres=$genres' : ''
      }${
        from != null && to != null ? '&from=$from&to=$to' : ''
      }"
    );
  }
}