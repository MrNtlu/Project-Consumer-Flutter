class GameDetailsRelation {
  final String id;
  final List<String> platforms;
  final String title;
  final String titleOriginal;
  final int rawgId;
  final String? releasedate;
  final String imageURL;

  GameDetailsRelation(
    this.id, this.platforms, this.title,
    this.titleOriginal, this.rawgId, 
    this.releasedate, this.imageURL
  );
}