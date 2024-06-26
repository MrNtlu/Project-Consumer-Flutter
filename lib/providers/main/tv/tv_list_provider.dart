import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/providers/common/base_pagination_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes.dart';

class TVListProvider extends BasePaginationProvider<BaseContent> {

  Future<BasePaginationResponse<BaseContent>> getTVSeries({
    int page = 1,
    required String contentTag,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    if (contentTag == Constants.ContentTags[0]) {
      return getList(
        url: "${APIRoutes().tvRoutes.tvBySortFilter}?page=$page&sort=popularity"
      );
    } else if (contentTag == Constants.ContentTags[1]) {
      return getList(
        url: "${APIRoutes().tvRoutes.upcomingTVSeries}?page=$page"
      );
    } else if (contentTag == Constants.ContentTags[2]) {
      return getList(
        url: "${APIRoutes().tvRoutes.tvBySortFilter}?page=$page&sort=top&status=ended"
      );
    } else {
      return getList(
        url: "${APIRoutes().tvRoutes.airingTVSeries}?page=$page"
      );
    }
  }

  Future<BasePaginationResponse<BaseContent>> searchTVSeries({
    int page = 1,
    required String search,
  }) {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: "${APIRoutes().tvRoutes.searchTVSeries}?page=$page&search=$search"
    );
  }

  Future<BasePaginationResponse<BaseContent>> discoverTVSeries({
    int page = 1,
    required String sort,
    String? status,
    String? numOfSeason,
    String? productionCompany,
    String? productionCountry,
    String? genres,
    int? from,
    int? to,
    int? rating,
    String? streaming,
    String streamingRegion = "",
  }) {
    if (page == 1) {
      pitems.clear();
    }

    final bool isStreamingRegionFiltered = streamingRegion != "WW";

    return getList(
      url: "${APIRoutes().tvRoutes.tvBySortFilter}?page=$page&sort=$sort${
        status != null ? '&status=$status' : ''
      }${
        numOfSeason != null ? '&season=$numOfSeason' : ''
      }${
        productionCompany != null ? '&production_companies=${Uri.encodeQueryComponent(productionCompany)}' : ''
      }${
        productionCountry != null ? '&production_country=${Uri.encodeQueryComponent(productionCountry)}' : ''
      }${
        genres != null ? '&genres=${Uri.encodeQueryComponent(genres)}' : ''
      }${
        streaming != null ? '&streaming_platforms=${Uri.encodeQueryComponent(streaming)}' : ''
      }${
        from != null && to != null ? '&from=$from&to=$to' : ''
      }${
        rating != null ? '&rating=$rating' : ''
      }${
        streaming != null
          ? isStreamingRegionFiltered
            ? '&is_region_filtered=true&region=${Uri.encodeQueryComponent(streamingRegion)}'
            : '&is_region_filtered=false'
          : ''
      }"
    );
  }
}