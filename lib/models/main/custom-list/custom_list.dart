import 'package:watchlistfy/models/main/review/author.dart';

class CustomList {
  final String id;
  final String userID;
  final Author author;
  final String name;
  final String? description;
  final List<String> likes;
  final List<String> bookmarks;
  int popularity;
  int bookmarkCount;
  bool isLiked;
  bool isBookmarked;
  bool isPrivate;
  final List<CustomListContent> content;
  final String createdAt;

  CustomList(
    this.id, this.userID, this.author, this.name, this.description,
    this.likes, this.bookmarks, this.popularity, this.bookmarkCount,
    this.isLiked, this.isBookmarked, this.isPrivate, this.content, this.createdAt
  );
}

class CustomListContent {
  int order;
  final String contentID;
  final String? contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final String titleEn;
  final String titleOriginal;
  final String? imageURL;
  final double? score;

  CustomListContent(
    this.order, this.contentID, this.contentExternalID,
    this.contentExternalIntID, this.contentType, this.titleEn,
    this.titleOriginal, this.imageURL, this.score,
  );
}
