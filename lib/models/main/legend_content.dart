class LegendContent {
  final String id;
  final String imageUrl;
  final String titleEn;
  final String titleOriginal;
  final int timesFinished;
  final String contentType;
  final int? hoursPlayed;

  LegendContent(
    this.id, this.imageUrl, this.titleEn, 
    this.titleOriginal, this.timesFinished, this.contentType, this.hoursPlayed,
  );
}