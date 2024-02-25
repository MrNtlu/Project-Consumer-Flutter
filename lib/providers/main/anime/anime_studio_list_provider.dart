import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';

class AnimeStudioListProvider extends BasePaginationProvider<BaseContent> {
  String sort = Constants.SortRequestsStreamingPlatform[0].request;

  Future<BasePaginationResponse<BaseContent>> getAnimeByStudio({
    int page = 1,
    required String studio,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().animeRoutes.animeByStudio}?page=$page&sort=$sort&studio=${Uri.encodeQueryComponent(studio)}"
    );
  }
}