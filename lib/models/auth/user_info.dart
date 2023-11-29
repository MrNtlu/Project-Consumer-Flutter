class UserInfo {
  final String id;
  final bool isPremium;
  bool isFriendRequestSent;
  bool isFriendRequestReceived;
  final bool isFriendsWith;
  final int friendRequestCount;
  final int membershipType;
  final int animeCount;
  final int gameCount;
  final int movieCount;
  final int tvCount;
  final int movieWatchedTime;
  final int animeWatchedEpisodes;
  final int tvWatchedEpisodes;
  final int gameTotalHoursPlayed;
  final String fcmToken;

  final String username;
  final String email;
  final String? image;
  final int level;

  //TODO: https://github.com/MrNtlu/Project-Consumer-Android/blob/master/app/src/main/java/com/mrntlu/projectconsumer/models/auth/UserInfo.kt
  // Add Missing fields

  UserInfo(
    this.id, this.isPremium, this.isFriendRequestSent, this.isFriendRequestReceived,
    this.isFriendsWith, this.friendRequestCount, this.membershipType, this.animeCount,
    this.gameCount, this.movieCount, this.tvCount, this.movieWatchedTime, this.animeWatchedEpisodes,
    this.tvWatchedEpisodes, this.gameTotalHoursPlayed, this.fcmToken, this.username, this.email,
    this.image, this.level
  );
}
