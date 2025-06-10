import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/auth/basic_user_info.dart';

class AuthenticationProvider with ChangeNotifier {
  bool isAuthenticated = false;
  BasicUserInfo? basicUserInfo;

  void initAuthentication(bool isAuthenticated, BasicUserInfo? basicUserInfo) {
    this.isAuthenticated = isAuthenticated;
    this.basicUserInfo = basicUserInfo;
  }

  void setAuthentication(bool isAuthenticated) {
    if (this.isAuthenticated != isAuthenticated) {
      this.isAuthenticated = isAuthenticated;
      notifyListeners();
    }
  }

  void setBasicUserInfo(BasicUserInfo? basicUserInfo) {
    this.basicUserInfo = basicUserInfo;
    notifyListeners();
  }
}
