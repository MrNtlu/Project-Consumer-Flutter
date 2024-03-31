import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class GlobalProvider extends ChangeNotifier {
  String userListMode = Constants.UserListUIModes.first;
  String contentMode = Constants.ContentUIModes.first;
  String consumeLaterMode = Constants.ConsumeLaterUIModes.first;
  String statsMode = Constants.ProfileStatisticsUIModes.last;
  String selectedCountryCode = 'US';
  ContentType contentType = ContentType.movie;

  void initValues() {
    final sharedPref = SharedPref();
    userListMode = sharedPref.getUserListUIMode();
    contentMode = sharedPref.getContentUIMode();
    selectedCountryCode = sharedPref.getSelectedCountry();
    consumeLaterMode = sharedPref.getConsumeLaterUIMode();
    statsMode = sharedPref.getProfileStatisticsUIMode();
    contentType = ContentType.values
        .where((element) => element.request == sharedPref.getDefaultContent())
        .first;
  }

  void setContentMode(String mode) {
    if (mode != contentMode) {
      contentMode = mode;
      notifyListeners();
      SharedPref().setContentUIMode(mode);
    }
  }

  void setUserListMode(String mode) {
    if (mode != userListMode) {
      userListMode = mode;
      notifyListeners();
      SharedPref().setUserListUIMode(mode);
    }
  }

  void setConsumeLaterMode(String mode) {
    if (mode != consumeLaterMode) {
      consumeLaterMode = mode;
      notifyListeners();
      SharedPref().setConsumeLaterUIMode(mode);
    }
  }

  void setStatsMode(String mode) {
    if (mode != statsMode) {
      statsMode = mode;
      notifyListeners();
      SharedPref().setProfileStatisticsUIMode(mode);
    }
  }

  void setContentType(ContentType contentType) {
    if (contentType.request != this.contentType.request) {
      this.contentType = contentType;
      notifyListeners();
      SharedPref().setDefaultContent(contentType.request);
    }
  }

  void setSelectedCountry(String country) {
    if (country != selectedCountryCode) {
      selectedCountryCode = country;
      notifyListeners();
      SharedPref().setSelectedCountry(country);
    }
  }
}
