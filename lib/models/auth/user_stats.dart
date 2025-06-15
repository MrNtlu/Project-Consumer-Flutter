class UserStats {
  final List<MostLikedGenres> genres;
  final List<MostLikedCountry> countries;
  final List<FinishedLogStats> stats;
  final List<MostWatchedActors> actors;
  final List<MostLikedStudios> studios;
  final List<Logs> logs;

  // New fields from updated response
  final List<ContentTypeDistribution> contentTypeDistribution;
  final CompletionRate completionRate;
  final List<AverageRatingByType> averageRatingByType;

  UserStats(
    this.genres,
    this.countries,
    this.stats,
    this.actors,
    this.studios,
    this.logs,
    this.contentTypeDistribution,
    this.completionRate,
    this.averageRatingByType,
  );
}

class MostLikedGenres {
  final String type;
  final String genre;

  MostLikedGenres(this.type, this.genre);
}

class MostLikedCountry {
  final String type;
  final String country;

  MostLikedCountry(this.type, this.country);
}

class MostWatchedActors {
  final String type;
  final List<MostWatchedActor> actors;

  MostWatchedActors(this.type, this.actors);
}

class MostWatchedActor {
  final String id;
  final String name;
  final String image;

  MostWatchedActor(this.id, this.name, this.image);
}

class MostLikedStudios {
  final String type;
  final List<String> studios;

  MostLikedStudios(this.type, this.studios);
}

class FinishedLogStats {
  final String contentType;
  final int length;
  final int totalEpisodes;
  final int totalSeasons;
  final int metacriticScore;
  final int count;

  FinishedLogStats(
    this.contentType,
    this.length,
    this.totalEpisodes,
    this.totalSeasons,
    this.metacriticScore,
    this.count,
  );
}

class Logs {
  final int count;
  final String createdAt;
  final int dayOfWeek;

  Logs(this.count, this.createdAt, this.dayOfWeek);
}

// New classes for additional stats
class ContentTypeDistribution {
  final String contentType;
  final int count;
  final double percentage;

  ContentTypeDistribution(this.contentType, this.count, this.percentage);
}

class CompletionRate {
  final int totalContent;
  final int finishedContent;
  final int activeContent;
  final int droppedContent;
  final double completionRate;
  final double dropRate;

  CompletionRate(
    this.totalContent,
    this.finishedContent,
    this.activeContent,
    this.droppedContent,
    this.completionRate,
    this.dropRate,
  );
}

class AverageRatingByType {
  final String contentType;
  final double averageRating;
  final int totalRated;

  AverageRatingByType(this.contentType, this.averageRating, this.totalRated);
}
