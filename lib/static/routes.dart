import 'package:watchlistfy/static/constants.dart';

class APIRoutes {

  late final AuthRoutes authRoutes;
  late final OAuthRoutes oauthRoutes;
  late final UserRoutes userRoutes;

  APIRoutes._privateConstructor() {
    authRoutes = AuthRoutes(baseURL: Constants.BASE_API_URL);
    oauthRoutes = OAuthRoutes(baseURL: Constants.BASE_API_URL);
    userRoutes = UserRoutes(baseURL: Constants.BASE_API_URL);
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

  AuthRoutes({baseURL}) {
    _baseAuthURL = '$baseURL/auth';

    login = '$_baseAuthURL/login';
    register = '$_baseAuthURL/register';
    logout = '$_baseAuthURL/logout';
  }
}

class OAuthRoutes {
  late String _baseOAuthURL;

  late String google;

  OAuthRoutes({baseURL}) {
    _baseOAuthURL ='$baseURL/oauth';

    google = '$_baseOAuthURL/google';
  }
}

class UserRoutes {
  late String _baseUserURL;

  late String info;
  late String forgotPassword;
  late String changePassword;
  late String changeNotification;
  late String changeMembership;
  late String updateFCMToken;
  late String deleteUser;

  UserRoutes({baseURL}) {
    _baseUserURL = '$baseURL/user';

    info = '$_baseUserURL/info';
    forgotPassword = '$_baseUserURL/forgot-password';
    changePassword = '$_baseUserURL/change-password';
    changeNotification = '$_baseUserURL/change-notification';
    updateFCMToken = '$_baseUserURL/update-token';
    changeMembership = '$_baseUserURL/membership';
    deleteUser = _baseUserURL;
  }
}