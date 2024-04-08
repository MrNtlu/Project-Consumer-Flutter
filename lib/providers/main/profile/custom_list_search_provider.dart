import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/routes.dart';

class CustomListSearchProvider extends BasePaginationProvider<BaseContent> {

  Future<BasePaginationResponse<BaseContent>> searchContent({
    int page = 1,
    required ContentType selectedContent,
    required String search,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    String route;
    switch (selectedContent) {
      case ContentType.anime:
        route = APIRoutes().animeRoutes.searchAnime;
        break;
      case ContentType.game:
        route = APIRoutes().gameRoutes.searchGames;
        break;
      case ContentType.tv:
        route = APIRoutes().tvRoutes.searchTVSeries;
        break;
      default:
        route = APIRoutes().movieRoutes.searchMovies;
        break;
    }
    
    
    return getList(
      url: "$route?page=$page&search=$search"
    );
  }
}