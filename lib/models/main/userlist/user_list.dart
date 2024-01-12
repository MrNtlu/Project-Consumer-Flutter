import 'package:watchlistfy/models/main/userlist/user_list_content.dart';

class UserList {
  final String id;
  final String userID;

  final List<UserListContent> animeList;
  final List<UserListContent> gameList;
  final List<UserListContent> movieList;
  final List<UserListContent> tvList;

  UserList(this.id, this.userID, this.animeList, this.gameList, this.movieList, this.tvList);
}
