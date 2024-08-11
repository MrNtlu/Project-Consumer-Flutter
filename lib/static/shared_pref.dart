import 'package:flutter/cupertino.dart';
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
  void setIsIntroductionPresented(bool isPresented) {
    sharedPref?.setBool(Constants.INTRODUCTION_PREF, isPresented);
  }

  bool getIsIntroductionPresented() {
    return _sharedPreference.getBool(Constants.INTRODUCTION_PREF) ?? false;
  }

  //Feedback
  void setCanShowFeedbackDialog(bool canShow) {
    sharedPref?.setBool(Constants.FEEDBACK_PREF, canShow);
  }

  bool getCanShowFeedbackDialog() {
    return _sharedPreference.getBool(Constants.FEEDBACK_PREF) ?? true;
  }

  //What's New
  void setShouldShowWhatsNewDialog(bool shouldShow) {
    sharedPref?.setBool(Constants.WHATSNEW_PREF, shouldShow);
  }

  bool getShouldShowWhatsNewDialog() {
    return _sharedPreference.getBool(Constants.WHATSNEW_PREF) ?? true;
  }

  final newVersion = "1_6_7";
  final oldVersion = "1_6_6";

  void setDidShowVersionPatch(bool didShow) {
    sharedPref?.setBool(newVersion, didShow);
    sharedPref?.remove(oldVersion);
  }

  bool getDidShowVersionPatch() {
    return _sharedPreference.getBool(newVersion) ?? false;
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
  void setContentUIMode(String mode) {
    sharedPref?.setString("content_ui_mode", mode);
  }

  String getContentUIMode() {
    return _sharedPreference.getString("content_ui_mode") ?? Constants.ContentUIModes.first;
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

  //Profile Stats Mode
  void setProfileStatisticsUIMode(String mode) {
    sharedPref?.setString("profile_statistics_ui_mode", mode);
  }

  String getProfileStatisticsUIMode() {
    return _sharedPreference.getString("profile_statistics_ui_mode") ?? Constants.ProfileStatisticsUIModes.last;
  }

  //Country Selection
  void setSelectedCountry(String country) {
    sharedPref?.setString("selected_country", country);
  }

  String getSelectedCountry() {
    return _sharedPreference.getString("selected_country") ?? WidgetsBinding.instance.platformDispatcher.locale.countryCode ?? 'US';
  }

  //Ask for Review
  void setIsAskedForReview(bool isAsked) {
    sharedPref?.setBool("is_asked_for_review", isAsked);
  }

  bool getIsAskedForReview() {
    return _sharedPreference.getBool("is_asked_for_review") ?? false;
  }
}