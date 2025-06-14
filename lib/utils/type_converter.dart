import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/models/auth/user_stats.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/main/ai/suggestion_response.dart';
import 'package:watchlistfy/models/main/anime/anime_details.dart';
import 'package:watchlistfy/models/main/anime/anime_details_air_date.dart';
import 'package:watchlistfy/models/main/anime/anime_details_character.dart';
import 'package:watchlistfy/models/main/anime/anime_details_name_url.dart';
import 'package:watchlistfy/models/main/anime/anime_details_recommendation.dart';
import 'package:watchlistfy/models/main/anime/anime_details_relation.dart';
import 'package:watchlistfy/models/main/anime/anime_watch_list.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/models/main/common/actor.dart';
import 'package:watchlistfy/models/main/common/actor_details.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/consume_later_response.dart';
import 'package:watchlistfy/models/main/common/production_company.dart';
import 'package:watchlistfy/models/main/common/recommendation.dart';
import 'package:watchlistfy/models/main/common/review_summary.dart';
import 'package:watchlistfy/models/main/common/streaming.dart';
import 'package:watchlistfy/models/main/common/streaming_platform.dart';
import 'package:watchlistfy/models/main/common/trailer.dart';
import 'package:watchlistfy/models/main/custom-list/custom_list.dart';
import 'package:watchlistfy/models/main/game/game_details.dart';
import 'package:watchlistfy/models/main/game/game_details_relation.dart';
import 'package:watchlistfy/models/main/game/game_details_store.dart';
import 'package:watchlistfy/models/main/game/game_play_list.dart';
import 'package:watchlistfy/models/main/legend_content.dart';
import 'package:watchlistfy/models/main/movie/movie_details.dart';
import 'package:watchlistfy/models/main/movie/movie_watch_list.dart';
import 'package:watchlistfy/models/main/recommendation/recommendation.dart';
import 'package:watchlistfy/models/main/review/author.dart';
import 'package:watchlistfy/models/main/review/review.dart';
import 'package:watchlistfy/models/main/review/review_with_content.dart';
import 'package:watchlistfy/models/main/social/leaderboard.dart';
import 'package:watchlistfy/models/main/social/social.dart';
import 'package:watchlistfy/models/main/tv/tv_details.dart';
import 'package:watchlistfy/models/main/tv/tv_details_network.dart';
import 'package:watchlistfy/models/main/tv/tv_details_season.dart';
import 'package:watchlistfy/models/main/tv/tv_watch_list.dart';
import 'package:watchlistfy/models/main/userlist/user_list.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';

class TypeConverter<T> {
  T convertToObject(Map<String, dynamic> response) {
    if (T == BasicUserInfo) {
      return BasicUserInfo(
        response["_id"],
        response["fcm_token"] ?? "",
        response["is_oauth"] ?? false,
        response["is_premium"] ?? false,
        response["membership_type"] ?? -1,
        response["oauth_type"] ?? -1,
        response["can_change_username"] ?? false,
        Notification(
          response["app_notification"]["promotions"] ?? true,
          response["app_notification"]["updates"] ?? true,
          response["app_notification"]["follows"] ?? true,
          response["app_notification"]["review_likes"] ?? true,
        ),
        response["mail_notification"] != null
            ? Notification(
                response["mail_notification"]["promotions"] ?? true,
                response["mail_notification"]["updates"] ?? true,
                response["mail_notification"]["follows"] ?? false,
                response["mail_notification"]["review_likes"] ?? false,
              )
            : Notification(true, true, false, false),
        response["email"],
        response["image"],
        response["username"],
        response["streak"] ?? 0,
        response["user_list_count"] ?? 0,
        response["consume_later_count"] ?? 0,
        response["created_at"],
      ) as T;
    } else if (T == UserInfo) {
      return UserInfo(
          response["_id"],
          response["is_premium"] ?? false,
          response["is_friend_request_sent"] ?? false,
          response["is_friend_request_received"] ?? false,
          response["is_friends_with"] ?? false,
          response["friend_request_count"] ?? 0,
          response["membership_type"],
          response["anime_count"] ?? 0,
          response["game_count"] ?? 0,
          response["movie_count"] ?? 0,
          response["tv_count"] ?? 0,
          response["movie_watched_time"] ?? 0,
          response["anime_watched_episodes"] ?? 0,
          response["tv_watched_episodes"] ?? 0,
          response["game_total_hours_played"] ?? 0,
          response["movie_total_score"] is double
              ? response["movie_total_score"]
              : (response["movie_total_score"] as int).toDouble(),
          response["tv_total_score"] is double
              ? response["tv_total_score"]
              : (response["tv_total_score"] as int).toDouble(),
          response["anime_total_score"] is double
              ? response["anime_total_score"]
              : (response["anime_total_score"] as int).toDouble(),
          response["game_total_score"] is double
              ? response["game_total_score"]
              : (response["game_total_score"] as int).toDouble(),
          response["fcm_token"],
          response["created_at"],
          response["username"],
          response["email"],
          response["image"],
          response["level"] ?? 0,
          response["max_streak"] ?? 0,
          response["streak"] ?? 0,
          response["consume_later"] != null
              ? ((response["consume_later"] as List)
                  .map((e) =>
                      TypeConverter<ConsumeLaterResponse>().convertToObject(e))
                  .toList())
              : [],
          response["legend_content"] != null
              ? ((response["legend_content"] as List)
                  .map((e) => TypeConverter<LegendContent>().convertToObject(e))
                  .toList())
              : [],
          response["reviews"] != null
              ? ((response["reviews"] as List)
                  .map((e) =>
                      TypeConverter<ReviewWithContent>().convertToObject(e))
                  .toList())
              : [],
          response["custom_lists"] != null
              ? ((response["custom_lists"] as List)
                  .map((e) => TypeConverter<CustomList>().convertToObject(e))
                  .toList())
              : []) as T;
    } else if (T == Leaderboard) {
      return Leaderboard(
        response["image"],
        response["username"],
        response["is_premium"] ?? false,
        response["level"],
        response["user_id"],
      ) as T;
    } else if (T == Social) {
      return Social(
        response["custom_lists"] != null
            ? ((response["custom_lists"] as List)
                .map((e) => TypeConverter<CustomList>().convertToObject(e))
                .toList())
            : [],
        response["reviews"] != null
            ? ((response["reviews"] as List)
                .map((e) =>
                    TypeConverter<ReviewWithContent>().convertToObject(e))
                .toList())
            : [],
        response["leaderboard"] != null
            ? ((response["leaderboard"] as List)
                .map((e) => TypeConverter<Leaderboard>().convertToObject(e))
                .toList())
            : [],
        response["recommendations"] != null
            ? ((response["recommendations"] as List)
                .map((e) => TypeConverter<RecommendationWithContent>()
                    .convertToObject(e))
                .toList())
            : [],
      ) as T;
    } else if (T == UserListContent) {
      return UserListContent(
        response["_id"],
        response["status"],
        response["score"],
        response["times_finished"],
        response["watched_episodes"] ?? response["hours_played"],
        response["watched_seasons"],
        response["total_episodes"],
        response["total_seasons"],
        "",
        "",
        "",
        "",
        "",
        response["created_at"],
      ) as T;
    } else if (T == BaseContent) {
      return BaseContent(
        response["_id"] ?? '',
        response["description"] ?? '',
        response["image_url"] ?? '',
        response["title_en"] ??
            (response["title"] ?? (response["title_jp"] ?? '')),
        response["title_original"] ?? '',
        response["tmdb_id"],
        response["mal_id"] ?? response["rawg_id"],
        ((response["mal_score"] ??
                response["tmdb_vote"] ??
                response["rawg_rating"] ??
                0) is double)
            ? response["mal_score"] ??
                response["tmdb_vote"] ??
                response["rawg_rating"] ??
                0.0
            : ((response["mal_score"] ??
                    response["tmdb_vote"] ??
                    response["rawg_rating"] ??
                    0) as int)
                .toDouble(),
        response["episodes"] ??
            response["length"] ??
            response["total_seasons"] ??
            response["metacritic_score"],
        response["source"] ??
            response["total_episodes"]?.toString() ??
            response["release_date"] ??
            response["status"],
      ) as T;
    } else if (T == UserList) {
      return UserList(
        response["_id"] ?? '',
        response["user_id"] ?? '',
        response["anime_list"] != null
            ? ((response["anime_list"] as List)
                .map((e) => UserListContent(
                      e["_id"],
                      e["content_status"],
                      e["score"],
                      e["times_finished"],
                      e["watched_episodes"],
                      null,
                      e["total_episodes"],
                      null,
                      e["anime_id"],
                      e["mal_id"].toString(),
                      e["image_url"],
                      e["title_en"],
                      e["title_original"],
                      e["created_at"],
                    ))
                .toList())
            : [],
        response["game_list"] != null
            ? ((response["game_list"] as List)
                .map((e) => UserListContent(
                      e["_id"],
                      e["content_status"],
                      e["score"],
                      e["times_finished"],
                      e["hours_played"],
                      null,
                      null,
                      null,
                      e["game_id"],
                      e["rawg_id"].toString(),
                      e["image_url"],
                      e["title"],
                      e["title_original"],
                      e["created_at"],
                    ))
                .toList())
            : [],
        response["movie_watch_list"] != null
            ? ((response["movie_watch_list"] as List)
                .map((e) => UserListContent(
                      e["_id"],
                      e["content_status"],
                      e["score"],
                      e["times_finished"],
                      null,
                      null,
                      null,
                      null,
                      e["movie_id"],
                      e["tmdb_id"],
                      e["image_url"],
                      e["title_en"],
                      e["title_original"],
                      e["created_at"],
                    ))
                .toList())
            : [],
        response["tv_watch_list"] != null
            ? ((response["tv_watch_list"] as List)
                .map((e) => UserListContent(
                      e["_id"],
                      e["content_status"],
                      e["score"],
                      e["times_finished"],
                      e["watched_episodes"],
                      e["watched_seasons"],
                      e["total_episodes"],
                      e["total_seasons"],
                      e["tv_id"],
                      e["tmdb_id"],
                      e["image_url"],
                      e["title_en"],
                      e["title_original"],
                      e["created_at"],
                    ))
                .toList())
            : [],
      ) as T;
    } else if (T == LegendContent) {
      return LegendContent(
        response["_id"] ?? '',
        response["image_url"] ?? '',
        response["title_en"] ?? '',
        response["title_original"] ?? '',
        response["times_finished"] ?? 0,
        response["content_type"] ?? '',
        response["hours_played"],
      ) as T;
    } else if (T == CustomListContent) {
      return CustomListContent(
          response["order"],
          response["content_id"],
          response["content_external_id"],
          response["content_external_int_id"],
          response["content_type"],
          response["title_en"],
          response["title_original"],
          response["image_url"],
          response["score"] != null
              ? (response["score"] is double
                  ? response["score"]
                  : (response["score"] as int).toDouble())
              : null) as T;
    } else if (T == CustomList) {
      return CustomList(
        response["_id"],
        response["user_id"],
        TypeConverter<Author>().convertToObject(response["author"]),
        response["name"],
        response["description"],
        (response["likes"] as List).map((e) => e.toString()).toList(),
        (response["bookmarks"] as List).map((e) => e.toString()).toList(),
        response["popularity"] ?? 0,
        response["bookmark_count"] ?? 0,
        response["is_liked"] ?? false,
        response["is_bookmarked"] ?? false,
        response["is_private"] ?? true,
        response["content"] != null
            ? ((response["content"] as List)
                .map((e) =>
                    TypeConverter<CustomListContent>().convertToObject(e))
                .toList())
            : [],
        response["created_at"],
      ) as T;
    } else if (T == Author) {
      return Author(
          image: response["image"],
          username: response["username"],
          email: response["email"],
          id: response["_id"],
          isPremium: response["is_premium"]) as T;
    } else if (T == Review) {
      return Review(
          author: TypeConverter<Author>().convertToObject(response["author"]),
          star: response["star"],
          review: response["review"],
          popularity: response["popularity"],
          likes: (response["likes"] as List).map((e) => e.toString()).toList(),
          isAuthor: response["is_author"],
          isSpoiler: response["is_spoiler"],
          isLiked: response["is_liked"],
          id: response["_id"],
          userID: response["user_id"],
          contentID: response["content_id"],
          contentExternalID: response["content_external_id"],
          contentExternalIntID: response["content_external_int_id"],
          contentType: response["content_type"],
          createdAt: response["created_at"],
          updatedAt: response["updated_at"]) as T;
    } else if (T == ReviewSummary) {
      return ReviewSummary(
          response["reviews"]["review"] != null
              ? TypeConverter<Review>()
                  .convertToObject(response["reviews"]["review"])
              : null,
          (response["reviews"]["avg_star"] as int).toDouble(),
          response["reviews"]["total_votes"],
          response["reviews"]["is_reviewed"],
          StarCounts(
              response["reviews"]["star_counts"]["one_star"],
              response["reviews"]["star_counts"]["two_star"],
              response["reviews"]["star_counts"]["three_star"],
              response["reviews"]["star_counts"]["four_star"],
              response["reviews"]["star_counts"]["five_star"])) as T;
    } else if (T == ReviewWithContent) {
      return ReviewWithContent(
          author: TypeConverter<Author>().convertToObject(response["author"]),
          star: response["star"],
          review: response["review"],
          popularity: response["popularity"],
          likes: (response["likes"] as List).map((e) => e.toString()).toList(),
          isAuthor: response["is_author"],
          isLiked: response["is_liked"],
          isSpoiler: response["is_spoiler"],
          id: response["_id"],
          userID: response["user_id"],
          contentID: response["content_id"],
          contentExternalID: response["content_external_id"],
          contentExternalIntID: response["content_external_int_id"],
          contentType: response["content_type"],
          createdAt: response["created_at"],
          updatedAt: response["updated_at"],
          content: TypeConverter<ReviewContent>()
              .convertToObject(response["content"])) as T;
    } else if (T == RecommendationWithContent) {
      return RecommendationWithContent(
        author: TypeConverter<Author>().convertToObject(response["author"]),
        reason: response["reason"],
        popularity: response["popularity"],
        likes: (response["likes"] as List).map((e) => e.toString()).toList(),
        isAuthor: response["is_author"],
        isLiked: response["is_liked"],
        id: response["_id"],
        userID: response["user_id"],
        contentID: response["content_id"],
        recommendationID: response["recommendation_id"],
        contentType: response["content_type"],
        createdAt: response["created_at"],
        content:
            TypeConverter<ReviewContent>().convertToObject(response["content"]),
        recommendationContent: TypeConverter<ReviewContent>()
            .convertToObject(response["recommendation_content"]),
      ) as T;
    } else if (T == ReviewContent) {
      return ReviewContent(
          titleEn: response["title_en"],
          titleOriginal: response["title_original"],
          imageURL: response["image_url"]) as T;
    } else if (T == ActorDetails) {
      return ActorDetails(
        response["_id"],
        response["image_url"],
        response["name"],
      ) as T;
    } else if (T == ConsumeLater) {
      return ConsumeLater(
          response["_id"],
          response["user_id"],
          response["content_id"],
          response["content_external_id"],
          response["content_external_int_id"],
          response["content_type"]) as T;
    } else if (T == SuggestionResponse) {
      return SuggestionResponse(
        response["_id"] ?? '',
        response["content_id"] ?? '',
        response["content_external_id"] ?? '',
        response["content_external_int_id"],
        response["content_type"],
        response["title_en"] ?? '',
        response["title_original"] ?? '',
        response["image_url"] ?? '',
        response["score"] != null
            ? (response["score"] is double
                ? response["score"]
                : (response["score"] as int).toDouble())
            : 0,
        response["description"] ?? '',
        response["watch_later"] != null
            ? TypeConverter<ConsumeLaterSuggestionResponse>().convertToObject(
                response["watch_later"],
              )
            : null,
        response["not_interested"] ?? false,
      ) as T;
    } else if (T == ConsumeLaterSuggestionResponse) {
      return ConsumeLaterSuggestionResponse(
        response["_id"],
        response["user_id"],
        response["content_id"],
        response["content_external_id"],
        response["content_external_int_id"],
        response["content_type"],
        response["created_at"],
        TypeConverter<ConsumeLaterSuggestionContent>().convertToObject(
          response["content"],
        ),
      ) as T;
    } else if (T == ConsumeLaterSuggestionContent) {
      return ConsumeLaterSuggestionContent(
        response["title_en"],
        response["title_original"],
        response["image_url"],
        response["score"] != null
            ? (response["score"] is double
                ? response["score"]
                : (response["score"] as int).toDouble())
            : null,
        response["description"],
      ) as T;
    } else if (T == ConsumeLaterResponse) {
      return ConsumeLaterResponse(
        response["_id"],
        response["user_id"],
        response["content_id"],
        response["content_external_id"],
        response["content_external_int_id"] ?? 0,
        response["content_type"],
        response["created_at"],
        TypeConverter<ConsumeLaterContent>()
            .convertToObject(response["content"]),
      ) as T;
    } else if (T == ConsumeLaterContent) {
      return ConsumeLaterContent(
        response["title_en"],
        response["title_original"],
        response["image_url"],
        response["score"] != null
            ? (response["score"] is double)
                ? response["score"]
                : (response["score"] as int).toDouble()
            : 0,
        response["description"],
      ) as T;
    } else if (T == MovieWatchList) {
      return MovieWatchList(
          response["_id"],
          response["movie_id"],
          response["movie_tmdb_id"],
          response["times_finished"],
          response["status"],
          response["created_at"],
          response["score"]) as T;
    } else if (T == TVWatchList) {
      return TVWatchList(
        response["_id"],
        response["tv_id"],
        response["tv_tmdb_id"],
        response["times_finished"],
        response["status"],
        response["created_at"],
        response["score"],
        response["watched_episodes"],
        response["watched_seasons"],
      ) as T;
    } else if (T == AnimeWatchList) {
      return AnimeWatchList(
        response["_id"],
        response["anime_id"],
        response["anime_mal_id"],
        response["times_finished"],
        response["status"],
        response["created_at"],
        response["score"],
        response["watched_episodes"],
      ) as T;
    } else if (T == GamePlayList) {
      return GamePlayList(
        response["_id"],
        response["game_id"],
        response["game_rawg_id"],
        response["times_finished"],
        response["status"],
        response["created_at"],
        response["score"],
        response["hours_played"],
      ) as T;
    } else if (T == StreamingPlatform) {
      return StreamingPlatform(response["logo"], response["name"]) as T;
    } else if (T == AnimeDetailsRelation) {
      return AnimeDetailsRelation(
        response["_id"],
        response["mal_id"],
        response["anime_id"],
        response["image_url"],
        response["title_en"],
        response["title_original"],
        response["relation"],
        response["type"],
      ) as T;
    } else if (T == AnimeNameUrl) {
      return AnimeNameUrl(
        response["name"],
        response["url"],
      ) as T;
    } else if (T == AnimeDetailsRecommendation) {
      return AnimeDetailsRecommendation(
        response["title"],
        response["mal_id"],
        response["image_url"],
      ) as T;
    } else if (T == AnimeDetailsCharacter) {
      return AnimeDetailsCharacter(response["name"], response["role"],
          response["image"], response["mal_id"]) as T;
    } else if (T == AnimeDetailsAirDate) {
      return AnimeDetailsAirDate(
        response["from"],
        response["to"],
        response["from_day"],
        response["from_month"],
        response["from_year"],
        response["to_day"],
        response["to_month"],
        response["to_year"],
      ) as T;
    } else if (T == GameDetailsRelation) {
      return GameDetailsRelation(
        response["_id"],
        response["platforms"] != null
            ? (response["platforms"] as List).map((e) => e.toString()).toList()
            : [],
        response["title"],
        response["title_original"],
        response["rawg_id"],
        response["release_date"],
        response["image_url"],
      ) as T;
    } else if (T == GameDetailsStore) {
      return GameDetailsStore(
        response["url"],
        response["store_id"],
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
          (response["tmdb_popularity"] is double)
              ? response["tmdb_popularity"]
              : (response["tmdb_popularity"] as int).toDouble(),
          (response["tmdb_vote"] is double)
              ? response["tmdb_vote"]
              : (response["tmdb_vote"] as int).toDouble(),
          response["tmdb_vote_count"],
          response["recommendations"] != null
              ? ((response["recommendations"] as List)
                  .map((e) => Recommendation(
                      e["description"],
                      e["tmdb_id"],
                      e["title_en"],
                      e["title_original"],
                      e["release_date"],
                      e["image_url"]))
                  .toList())
              : [],
          response["actors"] != null
              ? ((response["actors"] as List)
                  .map((e) => Actor(
                      e["tmdb_id"], e["name"], e["image"], e["character"]))
                  .toList())
              : [],
          TypeConverter<ReviewSummary>().convertToObject(response),
          response["streaming"] != null
              ? ((response["streaming"] as List)
                  .map((e) => Streaming(
                        e["country_code"],
                        e["buy_options"] != null
                            ? (e["buy_options"] as List)
                                .map((se) =>
                                    StreamingPlatform(se["logo"], se["name"]))
                                .toList()
                            : null,
                        e["rent_options"] != null
                            ? (e["rent_options"] as List)
                                .map((se) =>
                                    StreamingPlatform(se["logo"], se["name"]))
                                .toList()
                            : null,
                        e["streaming_platforms"] != null
                            ? (e["streaming_platforms"] as List)
                                .map((se) =>
                                    StreamingPlatform(se["logo"], se["name"]))
                                .toList()
                            : null,
                      ))
                  .toList())
              : null,
          response["production_companies"] != null
              ? ((response["production_companies"] as List)
                  .map((e) => ProductionAndCompany(
                      e["logo"], e["name"], e["origin_country"]))
                  .toList())
              : null,
          response["videos"] != null
              ? ((response["videos"] as List)
                  .map((e) => Trailer(e["name"], e["key"], e["type"]))
                  .toList())
              : null,
          response["watch_list"] != null
              ? TypeConverter<MovieWatchList>()
                  .convertToObject(response["watch_list"])
              : null,
          response["watch_later"] != null
              ? ConsumeLater(
                  response["watch_later"]["_id"],
                  response["watch_later"]["user_id"],
                  response["watch_later"]["content_id"],
                  response["watch_later"]["content_external_id"],
                  -1,
                  response["watch_later"]["content_type"])
              : null) as T;
    } else if (T == TVDetails) {
      return TVDetails(
          response["_id"],
          response["description"],
          response["genres"] != null
              ? (response["genres"] as List).map((e) => e.toString()).toList()
              : [],
          response["status"],
          response["backdrop"],
          response["images"] != null
              ? (response["images"] as List).map((e) => e.toString()).toList()
              : [],
          response["image_url"],
          response["imdb_id"],
          response["first_air_date"],
          response["title_en"],
          response["title_original"],
          response["tmdb_id"],
          (response["tmdb_popularity"] is double)
              ? response["tmdb_popularity"]
              : (response["tmdb_popularity"] as int).toDouble(),
          (response["tmdb_vote"] is double)
              ? response["tmdb_vote"]
              : (response["tmdb_vote"] as int).toDouble(),
          response["tmdb_vote_count"],
          response["recommendations"] != null
              ? ((response["recommendations"] as List)
                  .map((e) => Recommendation(
                      e["description"],
                      e["tmdb_id"],
                      e["title_en"],
                      e["title_original"],
                      e["release_date"],
                      e["image_url"]))
                  .toList())
              : [],
          response["actors"] != null
              ? ((response["actors"] as List)
                  .map((e) => Actor(
                      e["tmdb_id"], e["name"], e["image"], e["character"]))
                  .toList())
              : [],
          TypeConverter<ReviewSummary>().convertToObject(response),
          response["streaming"] != null
              ? ((response["streaming"] as List)
                  .map((e) => Streaming(
                        e["country_code"],
                        e["buy_options"] != null
                            ? (e["buy_options"] as List)
                                .map((se) =>
                                    StreamingPlatform(se["logo"], se["name"]))
                                .toList()
                            : null,
                        e["rent_options"] != null
                            ? (e["rent_options"] as List)
                                .map((se) =>
                                    StreamingPlatform(se["logo"], se["name"]))
                                .toList()
                            : null,
                        e["streaming_platforms"] != null
                            ? (e["streaming_platforms"] as List)
                                .map((se) =>
                                    StreamingPlatform(se["logo"], se["name"]))
                                .toList()
                            : null,
                      ))
                  .toList())
              : null,
          response["production_companies"] != null
              ? ((response["production_companies"] as List)
                  .map((e) => ProductionAndCompany(
                      e["logo"], e["name"], e["origin_country"]))
                  .toList())
              : null,
          response["total_episodes"] ?? 0,
          response["total_seasons"] ?? 0,
          response["networks"] != null
              ? ((response["networks"] as List)
                  .map((e) => TVDetailsNetwork(
                      e["logo"], e["name"], e["origin_country"]))
                  .toList())
              : null,
          response["seasons"] != null
              ? ((response["seasons"] as List)
                  .map((e) => TVDetailsSeason(e["name"], e["air_date"],
                      e["episode_count"], e["season_num"], e["image_url"]))
                  .toList())
              : [],
          response["videos"] != null
              ? ((response["videos"] as List)
                  .map((e) => Trailer(e["name"], e["key"], e["type"]))
                  .toList())
              : null,
          response["tv_list"] != null
              ? TypeConverter<TVWatchList>()
                  .convertToObject(response["tv_list"])
              : null,
          response["watch_later"] != null
              ? ConsumeLater(
                  response["watch_later"]["_id"],
                  response["watch_later"]["user_id"],
                  response["watch_later"]["content_id"],
                  response["watch_later"]["content_external_id"],
                  -1,
                  response["watch_later"]["content_type"])
              : null) as T;
    } else if (T == AnimeDetails) {
      return AnimeDetails(
          response["_id"],
          response["description"],
          response["type"],
          response["source"],
          response["episodes"],
          response["season"],
          response["year"],
          response["status"],
          response["backdrop"],
          TypeConverter<AnimeDetailsAirDate>()
              .convertToObject(response["aired"]),
          response["recommendations"] != null
              ? ((response["recommendations"] as List)
                  .map((e) => TypeConverter<AnimeDetailsRecommendation>()
                      .convertToObject(e))
                  .toList())
              : [],
          response["streaming"] != null
              ? ((response["streaming"] as List)
                  .map((e) => TypeConverter<AnimeNameUrl>().convertToObject(e))
                  .toList())
              : null,
          response["producers"] != null
              ? ((response["producers"] as List)
                  .map((e) => TypeConverter<AnimeNameUrl>().convertToObject(e))
                  .toList())
              : null,
          response["studios"] != null
              ? ((response["studios"] as List)
                  .map((e) => TypeConverter<AnimeNameUrl>().convertToObject(e))
                  .toList())
              : null,
          response["genres"] != null
              ? ((response["genres"] as List)
                  .map((e) => TypeConverter<AnimeNameUrl>().convertToObject(e))
                  .toList())
              : null,
          response["themes"] != null
              ? ((response["themes"] as List)
                  .map((e) => TypeConverter<AnimeNameUrl>().convertToObject(e))
                  .toList())
              : null,
          response["demographics"] != null
              ? ((response["demographics"] as List)
                  .map((e) => TypeConverter<AnimeNameUrl>().convertToObject(e))
                  .toList())
              : null,
          response["relations"] != null
              ? ((response["relations"] as List)
                  .map((e) =>
                      TypeConverter<AnimeDetailsRelation>().convertToObject(e))
                  .toList())
              : [],
          response["characters"] != null
              ? ((response["characters"] as List)
                  .map((e) =>
                      TypeConverter<AnimeDetailsCharacter>().convertToObject(e))
                  .toList())
              : [],
          TypeConverter<ReviewSummary>().convertToObject(response),
          response["title_en"],
          response["title_jp"],
          response["title_original"],
          response["image_url"],
          response["mal_id"],
          (response["mal_score"] is double)
              ? response["mal_score"]
              : (response["mal_score"] as int).toDouble(),
          response["mal_scored_by"],
          response["is_airing"],
          response["age_rating"],
          response["trailer"],
          response["anime_list"] != null
              ? TypeConverter<AnimeWatchList>()
                  .convertToObject(response["anime_list"])
              : null,
          response["watch_later"] != null
              ? ConsumeLater(
                  response["watch_later"]["_id"],
                  response["watch_later"]["user_id"],
                  response["watch_later"]["content_id"],
                  response["watch_later"]["content_external_id"],
                  -1,
                  response["watch_later"]["content_type"])
              : null) as T;
    } else if (T == GameDetails) {
      return GameDetails(
          response["_id"],
          response["description"],
          response["tba"],
          response["subreddit"],
          response["genres"] != null
              ? (response["genres"] as List).map((e) => e.toString()).toList()
              : [],
          response["tags"] != null
              ? (response["tags"] as List).map((e) => e.toString()).toList()
              : [],
          response["platforms"] != null
              ? (response["platforms"] as List)
                  .map((e) => e.toString())
                  .toList()
              : [],
          response["developers"] != null
              ? (response["developers"] as List)
                  .map((e) => e.toString())
                  .toList()
              : [],
          response["publishers"] != null
              ? (response["publishers"] as List)
                  .map((e) => e.toString())
                  .toList()
              : [],
          response["stores"] != null
              ? ((response["stores"] as List)
                  .map((e) =>
                      TypeConverter<GameDetailsStore>().convertToObject(e))
                  .toList())
              : [],
          response["screenshots"] != null
              ? (response["screenshots"] as List)
                  .map((e) => e.toString())
                  .toList()
              : [],
          TypeConverter<ReviewSummary>().convertToObject(response),
          response["title"],
          response["title_original"],
          response["image_url"],
          response["rawg_id"],
          (response["rawg_rating"] is double)
              ? response["rawg_rating"]
              : (response["rawg_rating"] as int).toDouble(),
          response["rawg_rating_count"],
          response["metacritic_score"],
          response["release_date"],
          response["age_rating"],
          response["related_games"] != null
              ? ((response["related_games"] as List)
                  .map((e) =>
                      TypeConverter<GameDetailsRelation>().convertToObject(e))
                  .toList())
              : [],
          response["game_list"] != null
              ? TypeConverter<GamePlayList>()
                  .convertToObject(response["game_list"])
              : null,
          response["watch_later"] != null
              ? ConsumeLater(
                  response["watch_later"]["_id"],
                  response["watch_later"]["user_id"],
                  response["watch_later"]["content_id"],
                  response["watch_later"]["content_external_id"],
                  -1,
                  response["watch_later"]["content_type"])
              : null) as T;
    } else if (T == UserStats) {
      return UserStats(
          response["genres"] != null
              ? ((response["genres"] as List)
                  .map((e) =>
                      TypeConverter<MostLikedGenres>().convertToObject(e))
                  .toList())
              : [],
          response["country"] != null
              ? ((response["country"] as List)
                  .map((e) =>
                      TypeConverter<MostLikedCountry>().convertToObject(e))
                  .toList())
              : [],
          response["stats"] != null
              ? ((response["stats"] as List)
                  .map((e) =>
                      TypeConverter<FinishedLogStats>().convertToObject(e))
                  .toList())
              : [],
          response["actors"] != null
              ? ((response["actors"] as List)
                  .map((e) =>
                      TypeConverter<MostWatchedActors>().convertToObject(e))
                  .toList())
              : [],
          response["studios"] != null
              ? ((response["studios"] as List)
                  .map((e) =>
                      TypeConverter<MostLikedStudios>().convertToObject(e))
                  .toList())
              : [],
          response["logs"] != null
              ? ((response["logs"] as List)
                  .map((e) => TypeConverter<Logs>().convertToObject(e))
                  .toList())
              : [],
          response["content_type_distribution"] != null
              ? ((response["content_type_distribution"] as List)
                  .map((e) => TypeConverter<ContentTypeDistribution>()
                      .convertToObject(e))
                  .toList())
              : [],
          response["completion_rate"] != null
              ? TypeConverter<CompletionRate>()
                  .convertToObject(response["completion_rate"])
              : CompletionRate(0, 0, 0, 0, 0.0, 0.0),
          response["average_rating_by_type"] != null
              ? ((response["average_rating_by_type"] as List)
                  .map((e) =>
                      TypeConverter<AverageRatingByType>().convertToObject(e))
                  .toList())
              : []) as T;
    } else if (T == ContentTypeDistribution) {
      return ContentTypeDistribution(
        response["content_type"],
        response["count"],
        (response["percentage"] is double)
            ? response["percentage"]
            : (response["percentage"] as int).toDouble(),
      ) as T;
    } else if (T == CompletionRate) {
      return CompletionRate(
        response["total_content"],
        response["finished_content"],
        response["active_content"],
        response["dropped_content"],
        (response["completion_rate"] is double)
            ? response["completion_rate"]
            : (response["completion_rate"] as int).toDouble(),
        (response["drop_rate"] is double)
            ? response["drop_rate"]
            : (response["drop_rate"] as int).toDouble(),
      ) as T;
    } else if (T == AverageRatingByType) {
      return AverageRatingByType(
        response["content_type"],
        (response["average_rating"] is double)
            ? response["average_rating"]
            : (response["average_rating"] as int).toDouble(),
        response["total_rated"],
      ) as T;
    } else if (T == MostLikedGenres) {
      return MostLikedGenres(
        response["type"],
        response["genre"],
      ) as T;
    } else if (T == MostLikedCountry) {
      return MostLikedCountry(
        response["type"],
        response["country"],
      ) as T;
    } else if (T == MostWatchedActors) {
      return MostWatchedActors(
        response["type"],
        response["actors"] != null
            ? (response["actors"] as List)
                .map((e) => MostWatchedActor(e["id"], e["name"], e["image"]))
                .toList()
            : [],
      ) as T;
    } else if (T == MostLikedStudios) {
      return MostLikedStudios(
        response["type"],
        response["studios"] != null
            ? (response["studios"] as List).map((e) => e.toString()).toList()
            : [],
      ) as T;
    } else if (T == FinishedLogStats) {
      return FinishedLogStats(
        response["content_type"],
        response["length"],
        response["total_episodes"],
        response["total_seasons"],
        response["metacritic_score"],
        response["count"],
      ) as T;
    } else if (T == Logs) {
      return Logs(
        response["count"],
        response["created_at"],
        response["day_of_week"],
      ) as T;
    } else if (T == BasePreviewResponse<BaseContent>) {
      return BasePreviewResponse<BaseContent>(
        upcomingResponse: response["upcoming"],
        popularResponse: response["popular"],
        topResponse: response["top"],
        extraResponse: response["extra"],
        actorsResponse: response["actors"],
        productionResponse: response["production_companies"],
        studiosResponse: response["studios"],
      ) as T;
    } else {
      return response as T;
    }
  }
}
