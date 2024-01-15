import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class GlobalProvider extends ChangeNotifier {
  String userListMode = Constants.UserListUIModes.first;
  ContentType contentType = ContentType.movie;

  void initValues() {
    final sharedPref = SharedPref();
    userListMode = sharedPref.getUserListUIMode();
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

  void setContentType(ContentType contentType) {
    if (contentType.request != this.contentType.request) {  
      this.contentType = contentType;
      notifyListeners();
      SharedPref().setDefaultContent(contentType.request);
    }
  }
}
