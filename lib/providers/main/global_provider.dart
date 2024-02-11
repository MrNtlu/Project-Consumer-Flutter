import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class GlobalProvider extends ChangeNotifier {
  String userListMode = Constants.UserListUIModes.first;
  String consumeLaterMode = Constants.ConsumeLaterUIModes.first;
  String selectedCountryCode = 'US';
  ContentType contentType = ContentType.movie;

  void initValues() {
    final sharedPref = SharedPref();
    userListMode = sharedPref.getUserListUIMode();
    selectedCountryCode = sharedPref.getSelectedCountry();
    consumeLaterMode = sharedPref.getConsumeLaterUIMode();
    contentType = ContentType.values
        .where((element) => element.request == sharedPref.getDefaultContent())
        .first;
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
