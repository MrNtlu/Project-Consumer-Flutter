enum ContentType {
  anime,
  movie,
  tv,
  game,
}

extension ContentTypeExtension on ContentType {
  String get value {
    switch (this) {
      case ContentType.anime:
        return "Anime";
      case ContentType.movie:
        return "Movie";
      case ContentType.tv:
        return "TV Series";
      case ContentType.game:
        return "Game";
    }
  }

  String get request {
    switch (this) {
      case ContentType.anime:
        return "anime";
      case ContentType.movie:
        return "movie";
      case ContentType.tv:
        return "tv";
      case ContentType.game:
        return "game";
    }
  }

  static ContentType fromStringValue(String value) {
    return ContentType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ContentType.movie,
    );
  }

  static ContentType fromStringRequest(String request) {
    return ContentType.values.firstWhere(
      (type) => type.request == request,
      orElse: () => ContentType.movie,
    );
  }
}