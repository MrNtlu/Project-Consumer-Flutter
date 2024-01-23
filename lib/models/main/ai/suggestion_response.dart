import 'package:watchlistfy/models/main/common/consume_later_response.dart';

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
  final ConsumeLaterResponse? consumeLater;

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
    this.consumeLater
  );
}