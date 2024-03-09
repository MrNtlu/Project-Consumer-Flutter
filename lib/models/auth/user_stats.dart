class UserStats {
  final List<MostLikedGenres> genres;
  final List<FinishedLogStats> stats;
  final List<Logs> logs;

  UserStats(this.genres, this.stats, this.logs);
}

class MostLikedGenres {
  final String type;
  final String genre;
  final int maxCount;

  MostLikedGenres(this.type, this.genre, this.maxCount);
}

class FinishedLogStats {
  final String contentType;
  final int length;
  final int totalEpisodes;
  final int totalSeasons;
  final int metacriticScore;
  final int count;

  FinishedLogStats(
    this.contentType, this.length, this.totalEpisodes,
    this.totalSeasons, this.metacriticScore, this.count,
  );
}

class Logs {
  final int count;
  final String createdAt;
  final int dayOfWeek;

  Logs(this.count, this.createdAt, this.dayOfWeek);
}