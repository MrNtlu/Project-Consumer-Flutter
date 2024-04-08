class BaseContent {
  final String id;
  final String description;
  final String imageUrl;
  final String titleEn;
  final String titleOriginal;
  final String? externalId;
  final int? externalIntId;
  final double? score;
  final int? extraInfo; // Anime episodes, movie length, tv series total seasons, game metacritic score
  final String? extraInfo2; // Anime source, movie status, tv series total_episodes covert to string, game release date

  BaseContent(
    this.id, this.description, this.imageUrl, this.titleEn,
    this.titleOriginal, this.externalId, this.externalIntId,
    this.score, this.extraInfo, this.extraInfo2
  );
}