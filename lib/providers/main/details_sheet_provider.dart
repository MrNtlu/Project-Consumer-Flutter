import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/common/backend_request_mapper.dart';
import 'package:watchlistfy/static/constants.dart';

class DetailsSheetProvider with ChangeNotifier {
  BackendRequestMapper selectedStatus = Constants.UserListStatus[0];

  void initStatus(BackendRequestMapper status) {
    selectedStatus = status;
  }

  void changeStatus(BackendRequestMapper status) {
    selectedStatus = status;
    notifyListeners();
  }
}
