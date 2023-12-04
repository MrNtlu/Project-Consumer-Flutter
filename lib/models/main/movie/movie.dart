import 'package:watchlistfy/models/main/base_content.dart';

class Movie extends BaseContent {

  Movie(
    id, description, imageUrl, titleEn, titleOriginal, externalId
  ):super(id, description, imageUrl, titleEn, titleOriginal, externalId, null);
}
