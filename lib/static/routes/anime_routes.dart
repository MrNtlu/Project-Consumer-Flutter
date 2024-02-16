class AnimeRoutes {
  late String _baseAnimeRoute;

  late String animeBySortFilter;
  late String upcomingAnime;
  late String popularAnime;
  late String airingAnime;
  late String searchAnime;
  late String animeDetails;

  AnimeRoutes({baseURL}) {
    _baseAnimeRoute = '$baseURL/anime';

    animeBySortFilter = _baseAnimeRoute;
    popularAnime = '$_baseAnimeRoute/popular';
    upcomingAnime = '$_baseAnimeRoute/upcoming';
    airingAnime = '$_baseAnimeRoute/airing';
    searchAnime = '$_baseAnimeRoute/search';
    animeDetails = '$_baseAnimeRoute/details';
  }
}
