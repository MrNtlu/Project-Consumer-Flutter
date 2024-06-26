import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/routes/anime_routes.dart';
import 'package:watchlistfy/static/routes/custom_list_routes.dart';
import 'package:watchlistfy/static/routes/game_routes.dart';
import 'package:watchlistfy/static/routes/movie_routes.dart';
import 'package:watchlistfy/static/routes/openai_routes.dart';
import 'package:watchlistfy/static/routes/recommendation_routes.dart';
import 'package:watchlistfy/static/routes/review_routes.dart';
import 'package:watchlistfy/static/routes/tv_routes.dart';
import 'package:watchlistfy/static/routes/user_interaction_routes.dart';
import 'package:watchlistfy/static/routes/user_list_routes.dart';

class APIRoutes {
  late final AuthRoutes authRoutes;
  late final OAuthRoutes oauthRoutes;
  late final UserRoutes userRoutes;
  late final PreviewRoutes previewRoutes;
  late final SocialRoutes socialRoutes;
  late final MovieRoutes movieRoutes;
  late final TVSeriesRoutes tvRoutes;
  late final AnimeRoutes animeRoutes;
  late final GameRoutes gameRoutes;
  late final UserInteractionRoutes userInteractionRoutes;
  late final UserListRoutes userListRoutes;
  late final OpenAIRoutes openAIRoutes;
  late final ReviewRoutes reviewRoutes;
  late final RecommendationRoutes recommendationRoutes;
  late final CustomListRoutes customListRoutes;

  APIRoutes._privateConstructor() {
    authRoutes = AuthRoutes(baseURL: Constants.BASE_API_URL);
    oauthRoutes = OAuthRoutes(baseURL: Constants.BASE_API_URL);
    userRoutes = UserRoutes(baseURL: Constants.BASE_API_URL);
    previewRoutes = PreviewRoutes(baseURL: Constants.BASE_API_URL);
    socialRoutes = SocialRoutes(baseURL: Constants.BASE_API_URL);
    movieRoutes = MovieRoutes(baseURL: Constants.BASE_API_URL);
    tvRoutes = TVSeriesRoutes(baseURL: Constants.BASE_API_URL);
    animeRoutes = AnimeRoutes(baseURL: Constants.BASE_API_URL);
    gameRoutes = GameRoutes(baseURL: Constants.BASE_API_URL);
    userInteractionRoutes = UserInteractionRoutes(baseURL: Constants.BASE_API_URL);
    userListRoutes = UserListRoutes(baseURL: Constants.BASE_API_URL);
    openAIRoutes = OpenAIRoutes(baseURL: Constants.BASE_API_URL);
    reviewRoutes = ReviewRoutes(baseURL: Constants.BASE_API_URL);
    recommendationRoutes = RecommendationRoutes(baseURL: Constants.BASE_API_URL);
    customListRoutes = CustomListRoutes(baseURL: Constants.BASE_API_URL);
  }

  static final APIRoutes _instance = APIRoutes._privateConstructor();

  factory APIRoutes() {
    return _instance;
  }
}

class AuthRoutes {
  late String _baseAuthURL;

  late String login;
  late String register;
  late String logout;
  late String refresh;

  AuthRoutes({baseURL}) {
    _baseAuthURL = '$baseURL/auth';

    login = '$_baseAuthURL/login';
    register = '$_baseAuthURL/register';
    refresh = '$_baseAuthURL/refresh';
    logout = '$_baseAuthURL/logout';
  }
}

class OAuthRoutes {
  late String _baseOAuthURL;

  late String google;
  late String apple;

  OAuthRoutes({baseURL}) {
    _baseOAuthURL = '$baseURL/oauth';

    google = '$_baseOAuthURL/google';
    apple = '$_baseOAuthURL/apple';
  }
}

class UserRoutes {
  late String _baseUserURL;
  late String feedbackURL;

  late String info;
  late String profileFromUsername;
  late String statistics;
  late String basic;
  late String forgotPassword;
  late String changePassword;
  late String changeAppNotification;
  late String changeMailNotification;
  late String changeMembership;
  late String changeUsername;
  late String changeImage;
  late String updateFCMToken;
  late String deleteUser;

  UserRoutes({baseURL}) {
    _baseUserURL = '$baseURL/user';
    feedbackURL = '$baseURL/feedback';

    info = '$_baseUserURL/info';
    basic = '$_baseUserURL/basic';
    statistics = '$_baseUserURL/stats';
    profileFromUsername = '$_baseUserURL/profile';
    forgotPassword = '$_baseUserURL/forgot-password';
    changePassword = '$_baseUserURL/password';
    changeAppNotification = '$_baseUserURL/notification/app';
    changeMailNotification = '$_baseUserURL/notification/mail';
    updateFCMToken = '$_baseUserURL/token';
    changeMembership = '$_baseUserURL/membership';
    changeUsername = '$_baseUserURL/username';
    changeImage = '$_baseUserURL/image';
    deleteUser = _baseUserURL;
  }
}

class PreviewRoutes {
  late String _basePreviewRoute;

  late String preview;
  late String previewV2;

  PreviewRoutes({baseURL}) {
    _basePreviewRoute = '$baseURL/preview';

    preview = _basePreviewRoute;
    previewV2 = '$_basePreviewRoute/v2';
  }
}

class SocialRoutes {
  late String _baseSocialRoutes;

  late String social;

  SocialRoutes({baseURL}) {
    _baseSocialRoutes = '$baseURL/social';

    social = _baseSocialRoutes;
  }
}