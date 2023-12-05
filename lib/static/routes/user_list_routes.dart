class UserListRoutes {
  late String _baseUserListRoute;

  late String userList;
  late String movieUserList;
  late String tvUserList;
  late String animeUserList;
  late String gameUserList;
  late String deleteUserList;

  UserListRoutes({baseURL}) {
    _baseUserListRoute = '$baseURL/list';

    userList = _baseUserListRoute;
    movieUserList = '$_baseUserListRoute/movie';
    tvUserList = '$_baseUserListRoute/tv';
    animeUserList = '$_baseUserListRoute/anime';
    gameUserList = '$_baseUserListRoute/game';
  }
}
