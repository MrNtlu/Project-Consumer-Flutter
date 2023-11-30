// ignore_for_file: constant_identifier_names

import 'package:watchlistfy/models/common/backend_request_mapper.dart';

class Constants {
  static const BASE_API_URL = "https://watchlistfy-01e517696b58.herokuapp.com/api/v1";

  static const THEME_PREF = "theme";
  static const INTRODUCTION_PREF = "is_introduction_presented";
  static const TOKEN_PREF = "refresh_token";

  static final CONTENT_TYPES = [
    BackendRequestMapper("Movie", "movie"),
    BackendRequestMapper("TV Series", "tv"),
    BackendRequestMapper("Anime", "anime"),
    BackendRequestMapper("Game", "game"),
  ];
}