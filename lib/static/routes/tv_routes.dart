class TVSeriesRoutes {
  late String _baseTVRoute;

  late String tvBySortFilter;
  late String upcomingTVSeries;
  late String airingTVSeries;
  late String searchTVSeries;
  late String tvSeriesDetails;

  TVSeriesRoutes({baseURL}) {
    _baseTVRoute = '$baseURL/tv';

    tvBySortFilter = _baseTVRoute;
    upcomingTVSeries = '$_baseTVRoute/upcoming';
    airingTVSeries = '$_baseTVRoute/airing';
    searchTVSeries = '$_baseTVRoute/search';
    tvSeriesDetails = '$_baseTVRoute/details';
  }
}