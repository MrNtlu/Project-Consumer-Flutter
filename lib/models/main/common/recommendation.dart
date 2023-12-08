class Recommendation {
  final String description;
  final String tmdbID;
  final String title;
  final String titleOriginal;
  final String releaseDate;
  final String imageURL;

  Recommendation(
    this.description, this.tmdbID, this.title,
    this.titleOriginal, this.releaseDate, this.imageURL
  );
}