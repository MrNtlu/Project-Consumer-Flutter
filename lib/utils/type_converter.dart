import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/movie/movie.dart';

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
        response["id"] ?? '', 
        response["description"] ?? '', 
        response["image_url"] ?? '', 
        response["title_en"] ?? '', 
        response["title_original"] ?? '',
      ) as T;
    } else if (T == BasePreviewResponse<Movie>) {
      return BasePreviewResponse<Movie>(
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
