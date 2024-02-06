import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  var _isInit = false;
  late final SharedPreferences _sharedPreference;

  SharedPref._privateConstructor();

  Future init() async {
    if (!_isInit) {
      _sharedPreference = await SharedPreferences.getInstance().then((value) {
        _isInit = true;
        return value;
      });
    }
  }

  static final SharedPref _instance = SharedPref._privateConstructor();

  factory SharedPref() {
    return _instance;
  }

  SharedPreferences? get sharedPref => _isInit ? _sharedPreference : null;

  //Dark Theme
  void setTheme(bool isDarkTheme) {
    sharedPref?.setBool(Constants.THEME_PREF, isDarkTheme);
  }

  bool isDarkTheme() {
    return _sharedPreference.getBool(Constants.THEME_PREF) ?? true;
  }

  //Introduction
  void setIsIntroductionPresented(bool isIntroductionDeleted) {
    sharedPref?.setBool(Constants.INTRODUCTION_PREF, isIntroductionDeleted);
  }

  bool getIsIntroductionPresented() {
    return _sharedPreference.getBool(Constants.INTRODUCTION_PREF) ?? false;
  }

  //OAuth Refresh Token
  void setTokenCredentials(String token) {
    sharedPref?.setString(Constants.TOKEN_PREF, token);
  }

  String? getTokenCredentials() {
    return _sharedPreference.getString(Constants.TOKEN_PREF);
  }

  void deleteTokenCredentials(){
    sharedPref?.remove(Constants.TOKEN_PREF);
  }

  //Default Content Selection
  void setDefaultContent(String contentRequest) {
    sharedPref?.setString("default_content", contentRequest);
  }

  String getDefaultContent() {
    return _sharedPreference.getString("default_content") ?? ContentType.movie.request;
  }

  //User List Mode
  void setUserListUIMode(String mode) {
    sharedPref?.setString("user_list_ui_mode", mode);
  }

  String getUserListUIMode() {
    return _sharedPreference.getString("user_list_ui_mode") ?? Constants.UserListUIModes.first;
  }

  //Consume Later Mode
  void setConsumeLaterUIMode(String mode) {
    sharedPref?.setString("consume_later_ui_mode", mode);
  }

  String getConsumeLaterUIMode() {
    return _sharedPreference.getString("consume_later_ui_mode") ?? Constants.ConsumeLaterUIModes.first;
  }
}