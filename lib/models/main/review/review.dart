import 'package:watchlistfy/models/main/review/author.dart';

class Review {
  final Author author;
  final int star;
  final String review;
  final int popularity;
  final List<String> likes;
  final bool isAuthor;
  final bool isSpoiler;
  final bool isLiked;
  final String id;
  final String userID;
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final String createdAt;
  final String updatedAt;

  Review({
    required this.author,
    required this.star,
    required this.review,
    required this.popularity,
    required this.likes,
    required this.isAuthor,
    required this.isSpoiler,
    required this.isLiked,
    required this.id,
    required this.userID,
    required this.contentID,
    required this.contentExternalID,
    required this.contentExternalIntID,
    required this.contentType,
    required this.createdAt,
    required this.updatedAt,
  });
}