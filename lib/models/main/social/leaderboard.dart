class Leaderboard {
  final String? image;
  final String username;
  final bool isPremium;
  final int level;
  final String userID;
  
  Leaderboard(
    this.image, this.username, this.isPremium,
    this.level, this.userID,
  );
}