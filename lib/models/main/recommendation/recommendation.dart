import 'package:watchlistfy/models/main/review/author.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';

class RecommendationWithContent {
  final Author author;
  final String? reason;
  int popularity;
  final List<String> likes;
  final bool isAuthor;
  bool isLiked;
  final String id;
  final String userID;
  final String contentID;
  final String recommendationID;
  final String contentType;
  final String createdAt;
  final ReviewContent content;
  final ReviewContent recommendationContent;

  RecommendationWithContent({
    required this.author,
    required this.reason,
    required this.popularity,
    required this.likes,
    required this.isAuthor,
    required this.isLiked,
    required this.id,
    required this.userID,
    required this.contentID,
    required this.recommendationID,
    required this.contentType,
    required this.createdAt,
    required this.content,
    required this.recommendationContent,
  });
}
