class GameRoutes {
  late String _baseGameRoute;

  late String gameBySortFilter;
  late String upcomingGames;
  late String searchGames;
  late String gameDetails;

  GameRoutes({baseURL}) {
    _baseGameRoute = '$baseURL/game';

    gameBySortFilter = _baseGameRoute;
    upcomingGames = '$_baseGameRoute/upcoming';
    searchGames = '$_baseGameRoute/search';
    gameDetails = '$_baseGameRoute/details';
  }
}
