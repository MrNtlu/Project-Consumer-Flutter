import 'package:watchlistfy/models/main/review/author.dart';

class ReviewWithContent {
  final Author author;
  final int star;
  final String review;
  final int popularity;
  final List<String> likes;
  final bool isAuthor;
  final bool isLiked;
  final bool isSpoiler;
  final String id;
  final String userID;
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final String createdAt;
  final String updatedAt;
  final ReviewContent content;

  ReviewWithContent({
    required this.author,
    required this.star,
    required this.review,
    required this.popularity,
    required this.likes,
    required this.isAuthor,
    required this.isLiked,
    required this.isSpoiler,
    required this.id,
    required this.userID,
    required this.contentID,
    required this.contentExternalID,
    required this.contentExternalIntID,
    required this.contentType,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
  });
}

class ReviewContent {
  final String titleEn;
  final String titleOriginal;
  final String imageURL;

  ReviewContent({
    required this.titleEn,
    required this.titleOriginal,
    required this.imageURL,
  });
}