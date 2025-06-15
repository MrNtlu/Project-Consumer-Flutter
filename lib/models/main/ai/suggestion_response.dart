class SuggestionResponse {
  final String id;
  final String contentID;
  final String contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final String titleEn;
  final String titleOriginal;
  final String imageUrl;
  final double score;
  final String description;
  final ConsumeLaterSuggestionResponse? consumeLater;
  final bool isNotInterested;

  SuggestionResponse(
    this.id,
    this.contentID,
    this.contentExternalID,
    this.contentExternalIntID,
    this.contentType,
    this.titleEn,
    this.titleOriginal,
    this.imageUrl,
    this.score,
    this.description,
    this.consumeLater,
    this.isNotInterested,
  );
}

class ConsumeLaterSuggestionResponse {
  final String id;
  final String userID;
  final String contentID;
  final String contentExternalID;
  final int? contentExternalIntID;
  final String contentType;
  final String createdAt;
  final ConsumeLaterSuggestionContent content;

  ConsumeLaterSuggestionResponse(
    this.id,
    this.userID,
    this.contentID,
    this.contentExternalID,
    this.contentExternalIntID,
    this.contentType,
    this.createdAt,
    this.content,
  );
}

class ConsumeLaterSuggestionContent {
  final String titleEn;
  final String titleOriginal;
  final String? imageUrl;
  final double? score;
  final String description;

  ConsumeLaterSuggestionContent(
    this.titleEn,
    this.titleOriginal,
    this.imageUrl,
    this.score,
    this.description,
  );
}
