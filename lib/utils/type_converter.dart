import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/movie/movie.dart';
import 'package:watchlistfy/models/main/movie/movie_details.dart';

class TypeConverter<T> {
  T convertToObject(Map<String, dynamic> response) {
    if (T == BasicUserInfo) {
      return BasicUserInfo(
        response["fcm_token"] ?? "",
        response["is_oauth"] ?? false,
        response["is_premium"] ?? false,
        response["membership_type"] ?? -1,
        response["oauth_type"] ?? -1,
        response["can_change_username"] ?? false,
        Notification(
          response["app_notification"]["friend_request"] ?? false, 
          response["app_notification"]["review_likes"] ?? false
        ),
        response["email"],
        response["image"],
        response["username"],
      ) as T;
    } else if (T == Movie) {
      return Movie(
        response["_id"] ?? '', 
        response["description"] ?? '', 
        response["image_url"] ?? '', 
        response["title_en"] ?? '', 
        response["title_original"] ?? '',
        response["tmdb_id"],
      ) as T;
    } else if (T == BaseContent) {
      return BaseContent(
        response["_id"] ?? '', 
        response["description"] ?? '', 
        response["image_url"] ?? '', 
        response["title_en"] ?? (response["title"] ?? ''), 
        response["title_original"] ?? '',
        response["tmdb_id"],
        response["mal_id"] ?? response["rawg_id"]
      ) as T;
    } else if (T == MovieDetails) {
      return MovieDetails(
        response["_id"], 
        response["description"], 
        response["genres"] != null
        ? (response["genres"] as List).map((e) => e.toString()).toList()
        : [], 
        response["length"], 
        response["status"], 
        response["backdrop"], 
        response["images"] != null
        ? (response["images"] as List).map((e) => e.toString()).toList()
        : [], 
        response["image_url"], 
        response["imdb_id"], 
        response["release_date"], 
        response["title_en"], 
        response["title_original"], 
        response["tmdb_id"], 
        response["tmdb_popularity"], 
        response["tmdb_vote"], 
        response["tmdb_vote_count"], 
        null, // response["watch_list"], 
        response["watch_later"] != null
        ? ConsumeLater(
          response["watch_later"]["_id"], 
          response["watch_later"]["user_id"], 
          response["watch_later"]["content_id"], 
          response["watch_later"]["content_external_id"], -1, 
          response["watch_later"]["content_type"]
        )
        : null
      ) as T;
    } else if (T == BasePreviewResponse<BaseContent>) {
      return BasePreviewResponse<BaseContent>(
        upcomingResponse: response["upcoming"],
        popularResponse: response["popular"],
        topResponse: response["top"],
        extraResponse: response["extra"],
      ) as T;
    } else {
      return response as T;
    }
  }
}
