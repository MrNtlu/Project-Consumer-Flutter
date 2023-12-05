class MovieWatchList {
  final String id;
  final String movieID;
  final String tmdbID;
  final int timesFinished;
  final String status;
  final String createdAt;
  final int score;

  MovieWatchList(
    this.id, this.movieID, this.tmdbID, this.timesFinished,
    this.status, this.createdAt, this.score,
  );
}