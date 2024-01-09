class ConsumeLaterResponse {
  final String id;
  final String userID;
  final String contentID;
  final String contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final ConsumeLaterContent content;

  ConsumeLaterResponse(
      this.id,
      this.userID,
      this.contentID,
      this.contentExternalID,
      this.contentExternalIntID,
      this.contentType,
      this.content);
}

class ConsumeLaterContent {
  final String titleEn;
  final String titleOriginal;
  final String imageUrl;
  final double score;
  final String description;

  ConsumeLaterContent(this.titleEn, this.titleOriginal, this.imageUrl,
      this.score, this.description);
}
