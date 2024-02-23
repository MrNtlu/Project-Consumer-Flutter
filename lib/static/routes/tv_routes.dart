class TVSeriesRoutes {
  late String _baseTVRoute;

  late String tvBySortFilter;
  late String upcomingTVSeries;
  late String airingTVSeries;
  late String tvSeriesByActor;
  late String popularActors;
  late String searchTVSeries;
  late String tvSeriesDetails;
  late String popularStreamingPlatforms;
  late String tvSeriesByStreamingPlatform;

  TVSeriesRoutes({baseURL}) {
    _baseTVRoute = '$baseURL/tv';

    tvBySortFilter = _baseTVRoute;
    upcomingTVSeries = '$_baseTVRoute/upcoming';
    airingTVSeries = '$_baseTVRoute/airing';
    tvSeriesByActor = '$_baseTVRoute/actor';
    popularActors = '$_baseTVRoute/popular-actors';
    searchTVSeries = '$_baseTVRoute/search';
    tvSeriesDetails = '$_baseTVRoute/details';
    popularStreamingPlatforms = '$_baseTVRoute/popular-streaming-platforms';
    tvSeriesByStreamingPlatform = '$_baseTVRoute/streaming-platforms';
  }
}