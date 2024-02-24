
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';

class StreamingPlatformContentProvider extends BasePaginationProvider<BaseContent> {
  String sort = Constants.SortRequestsStreamingPlatform[0].request;

  Future<BasePaginationResponse<BaseContent>> getContentByStreamingPlatform({
    int page = 1,
    required String platform,
    required String region,
    required bool isMovie,
    required bool isAnime,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    if (isMovie) {
      return getList(
        url: "${APIRoutes().movieRoutes.moviesByStreamingPlatform}?page=$page&sort=$sort&platform=${Uri.encodeQueryComponent(platform)}&region=$region"
      );
    } else if (isAnime) {
      return getList(
        url: "${APIRoutes().animeRoutes.animeByStreamingPlatform}?page=$page&sort=$sort&platform=${Uri.encodeQueryComponent(platform)}"
      );
    } else {
      return getList(
        url: "${APIRoutes().tvRoutes.tvSeriesByStreamingPlatform}?page=$page&sort=$sort&platform=${Uri.encodeQueryComponent(platform)}&region=$region"
      );
    }
  }
}