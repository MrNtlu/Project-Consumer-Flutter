import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:watchlistfy/models/main/base_details.dart';
import 'package:watchlistfy/models/main/common/consume_later.dart';
import 'package:watchlistfy/models/main/common/request/delete_user_list_body.dart';
import 'package:watchlistfy/models/main/common/request/id_Body.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/ads_provider.dart';
import 'package:watchlistfy/static/interstitial_ad_handler.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';

abstract class BaseDetailsProvider<T extends DetailsModel> with ChangeNotifier {
  bool isLoading = false;
  bool isUserListLoading = false;
  DetailState state = DetailState.init;
  String? error;
  String? _currentId;

  @protected
  T? _item;

  T? get item => _item;

  set setItem(T item) {
    _item = item;
  }

  /// Initialize and fetch data with ads handling
  void initializeAndFetch(String id, AuthenticationProvider authProvider) {
    // Only fetch if we don't have data for this ID or if state is init
    if (_currentId != id || state == DetailState.init) {
      _currentId = id;
      fetchData(id);

      final shouldShowAds = authProvider.basicUserInfo == null ||
          authProvider.basicUserInfo?.isPremium == false;
      if (AdsTracker().shouldShowAds() && shouldShowAds) {
        InterstitialAdHandler().showAds();
      }
    }
  }

  /// Abstract method to be implemented by specific providers
  Future<void> fetchData(String id);

  /// Public method to trigger data refresh
  void refreshData(String id) {
    _currentId = id;
    fetchData(id);
  }

  @protected
  Future<BaseNullableResponse<T>> getDetails({required String url}) async {
    try {
      state = DetailState.loading;
      notifyListeners();

      final response = await http.get(
        Uri.parse(url),
        headers: UserToken().getBearerToken(),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      var baseItemResponse = decodedResponse.getBaseItemResponse<T>();
      var data = baseItemResponse.data;

      if (data != null) {
        state = DetailState.view;
        _item = data;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      state = DetailState.error;
      this.error = error.toString();
      notifyListeners();
      return BaseNullableResponse(
        message: error.toString(),
        error: error.toString(),
      );
    }
  }

  @protected
  Future<BaseNullableResponse<ConsumeLater>>
      createConsumeLater<Request extends JSONConverter>(
    Request request, {
    required String url,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode(request.convertToJson()),
          headers: UserToken().getBearerToken());

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      isLoading = false;
      var baseItemResponse =
          decodedResponse.getBaseItemResponse<ConsumeLater>();
      var data = baseItemResponse.data;

      if (data != null && _item != null) {
        _item!.consumeLater = data;
      }
      notifyListeners();

      return baseItemResponse;
    } catch (error) {
      isLoading = false;
      notifyListeners();

      return BaseNullableResponse(message: error.toString());
    }
  }

  @protected
  Future<BaseMessageResponse> deleteConsumeLater(
    IDBody body, {
    required String url,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(url),
        body: json.encode(
          body.convertToJson(),
        ),
        headers: UserToken().getBearerToken(),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      isLoading = false;
      var messageResponse = decodedResponse.getBaseMessageResponse();

      if (messageResponse.error == null) {
        _item!.consumeLater = null;
      }
      notifyListeners();

      return messageResponse;
    } catch (error) {
      isLoading = false;
      notifyListeners();

      return BaseMessageResponse(error.toString(), error.toString());
    }
  }

  @protected
  Future<BaseNullableResponse<UserList>> createUserList<
      Request extends JSONConverter, UserList extends BaseUserList>(
    Request request, {
    required String url,
  }) async {
    isUserListLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          request.convertToJson(),
        ),
        headers: UserToken().getBearerToken(),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      isUserListLoading = false;
      var baseItemResponse = decodedResponse.getBaseItemResponse<UserList>();
      var data = baseItemResponse.data;

      if (data != null && _item != null) {
        _item!.userList = data;
      }
      notifyListeners();

      return baseItemResponse;
    } catch (error) {
      isUserListLoading = false;
      notifyListeners();

      return BaseNullableResponse(message: error.toString());
    }
  }

  @protected
  Future<BaseNullableResponse<UserList>> updateUserList<
      Request extends JSONConverter, UserList extends BaseUserList>(
    Request request, {
    required String url,
  }) async {
    isUserListLoading = true;
    notifyListeners();

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(
          request.convertToJson(),
        ),
        headers: UserToken().getBearerToken(),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      isUserListLoading = false;
      var baseItemResponse = decodedResponse.getBaseItemResponse<UserList>();
      var data = baseItemResponse.data;

      if (data != null && _item != null) {
        _item!.userList = data;
      }
      notifyListeners();

      return baseItemResponse;
    } catch (error) {
      isUserListLoading = false;
      notifyListeners();

      return BaseNullableResponse(message: error.toString());
    }
  }

  @protected
  Future<BaseMessageResponse> deleteUserList(
    DeleteUserListBody body, {
    required String url,
  }) async {
    isUserListLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse(url),
        body: json.encode(
          body.convertToJson(),
        ),
        headers: UserToken().getBearerToken(),
      );

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      isUserListLoading = false;
      var messageResponse = decodedResponse.getBaseMessageResponse();

      if (messageResponse.error == null) {
        _item!.userList = null;
      }
      notifyListeners();

      return messageResponse;
    } catch (error) {
      isUserListLoading = false;
      notifyListeners();

      return BaseMessageResponse(error.toString(), error.toString());
    }
  }
}
