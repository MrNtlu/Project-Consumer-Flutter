class BaseContent {
  final String id;
  final String description;
  final String imageUrl;
  final String titleEn;
  final String titleOriginal;
  final String? externalId;
  final int? externalIntId;

  BaseContent(
    this.id, this.description, this.imageUrl, this.titleEn, 
    this.titleOriginal, this.externalId, this.externalIntId
  );
}