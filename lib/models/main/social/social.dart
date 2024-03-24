import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/models/main/recommendation/recommendation.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';
import 'package:watchlistfy/models/main/social/leaderboard.dart';

class Social {
  final List<CustomList> customList;
  final List<ReviewWithContent> reviews;
  final List<Leaderboard> leaderboard;
  final List<RecommendationWithContent> recommendations;

  Social(this.customList, this.reviews, this.leaderboard, this.recommendations);
}
