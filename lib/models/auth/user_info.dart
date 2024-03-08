import 'package:watchlistfy/models/main/common/consume_later_response.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/models/main/legend_content.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';

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
  final double movieAvgScore;
  final double tvAvgScore;
  final double animeAvgScore;
  final double gameAvgScore;
  final String fcmToken;

  final String username;
  final String email;
  final String? image;
  final int level;
  final int maxStreak;
  final int streak;

  final List<ConsumeLaterResponse> watchLater;
  final List<LegendContent> legendContent;
  final List<ReviewWithContent> reviews;
  final List<CustomList> customLists;

  UserInfo(
    this.id, this.isPremium, this.isFriendRequestSent, this.isFriendRequestReceived,
    this.isFriendsWith, this.friendRequestCount, this.membershipType, this.animeCount,
    this.gameCount, this.movieCount, this.tvCount, this.movieWatchedTime, this.animeWatchedEpisodes,
    this.tvWatchedEpisodes, this.gameTotalHoursPlayed, this.movieAvgScore, this.tvAvgScore,
    this.animeAvgScore, this.gameAvgScore, this.fcmToken, this.username, this.email,
    this.image, this.level, this.maxStreak, this.streak, this.watchLater,
    this.legendContent, this.reviews, this.customLists
  );
}
