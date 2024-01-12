class UserListRoutes {
  late String _baseUserListRoute;

  late String userList;
  late String movieUserList;
  late String tvUserList;
  late String tvIncrement;
  late String animeUserList;
  late String animeIncrement;
  late String gameUserList;
  late String gameIncrement;
  late String deleteUserList;

  UserListRoutes({baseURL}) {
    _baseUserListRoute = '$baseURL/list';

    userList = _baseUserListRoute;
    deleteUserList = _baseUserListRoute;
    movieUserList = '$_baseUserListRoute/movie';
    tvUserList = '$_baseUserListRoute/tv';
    tvIncrement = '$_baseUserListRoute/tv/inc';
    animeUserList = '$_baseUserListRoute/anime';
    animeIncrement = '$_baseUserListRoute/anime/inc';
    gameUserList = '$_baseUserListRoute/game';
    gameIncrement = '$_baseUserListRoute/game/inc';
  }
}
