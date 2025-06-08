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
  bool _isLoading = false;
  bool _isUserListLoading = false;
  DetailState _state = DetailState.init;
  String? _error;
  String? _currentId;

  @protected
  T? _item;

  // Performance optimization: Cache frequently accessed properties
  bool get isLoading => _isLoading;
  bool get isUserListLoading => _isUserListLoading;
  DetailState get state => _state;
  String? get error => _error;
  T? get item => _item;

  // Optimized setters with change detection
  set _setIsLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  set _setIsUserListLoading(bool value) {
    if (_isUserListLoading != value) {
      _isUserListLoading = value;
      notifyListeners();
    }
  }

  set _setState(DetailState value) {
    if (_state != value) {
      _state = value;
      notifyListeners();
    }
  }

  set _setError(String? value) {
    if (_error != value) {
      _error = value;
      notifyListeners();
    }
  }

  set setItem(T item) {
    _item = item;
    _setState = DetailState.view;
  }

  /// Initialize and fetch data with ads handling
  void initializeAndFetch(String id, AuthenticationProvider authProvider) {
    // Only fetch if we don't have data for this ID or if state is init
    if (_currentId != id || _state == DetailState.init) {
      _currentId = id;
      fetchData(id);

      // Optimize ads check
      if (_shouldShowAds(authProvider)) {
        InterstitialAdHandler().showAds();
      }
    }
  }

  // Extracted method for better performance
  bool _shouldShowAds(AuthenticationProvider authProvider) {
    return AdsTracker().shouldShowAds() &&
        (authProvider.basicUserInfo == null ||
            authProvider.basicUserInfo?.isPremium == false);
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
      _setState = DetailState.loading;

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
        _item = data;
        _setState = DetailState.view;
        _setError = null;
      } else {
        _setState = DetailState.error;
        _setError = baseItemResponse.error ?? "Unknown error";
      }

      return baseItemResponse;
    } catch (error) {
      _setState = DetailState.error;
      _setError = error.toString();
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
    _setIsLoading = true;

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode(request.convertToJson()),
          headers: UserToken().getBearerToken());

      final decodedResponse = await compute(
        jsonDecode,
        response.body,
      ) as Map<String, dynamic>;

      var baseItemResponse =
          decodedResponse.getBaseItemResponse<ConsumeLater>();
      var data = baseItemResponse.data;

      if (data != null && _item != null) {
        _item!.consumeLater = data;
        // Only notify listeners once for the combined change
        notifyListeners();
      }

      _setIsLoading = false;
      return baseItemResponse;
    } catch (error) {
      _setIsLoading = false;
      return BaseNullableResponse(message: error.toString());
    }
  }

  @protected
  Future<BaseMessageResponse> deleteConsumeLater(
    IDBody body, {
    required String url,
  }) async {
    _setIsLoading = true;

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

      var messageResponse = decodedResponse.getBaseMessageResponse();

      if (messageResponse.error == null && _item != null) {
        _item!.consumeLater = null;
        // Only notify listeners once for the combined change
        notifyListeners();
      }

      _setIsLoading = false;
      return messageResponse;
    } catch (error) {
      _setIsLoading = false;
      return BaseMessageResponse(error.toString(), error.toString());
    }
  }

  @protected
  Future<BaseNullableResponse<UserList>> createUserList<
      Request extends JSONConverter, UserList extends BaseUserList>(
    Request request, {
    required String url,
  }) async {
    _setIsUserListLoading = true;

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

      var baseItemResponse = decodedResponse.getBaseItemResponse<UserList>();
      var data = baseItemResponse.data;

      if (data != null && _item != null) {
        _item!.userList = data;
        // Only notify listeners once for the combined change
        notifyListeners();
      }

      _setIsUserListLoading = false;
      return baseItemResponse;
    } catch (error) {
      _setIsUserListLoading = false;
      return BaseNullableResponse(message: error.toString());
    }
  }

  @protected
  Future<BaseNullableResponse<UserList>> updateUserList<
      Request extends JSONConverter, UserList extends BaseUserList>(
    Request request, {
    required String url,
  }) async {
    _setIsUserListLoading = true;

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

      var baseItemResponse = decodedResponse.getBaseItemResponse<UserList>();
      var data = baseItemResponse.data;

      if (data != null && _item != null) {
        _item!.userList = data;
        // Only notify listeners once for the combined change
        notifyListeners();
      }

      _setIsUserListLoading = false;
      return baseItemResponse;
    } catch (error) {
      _setIsUserListLoading = false;
      return BaseNullableResponse(message: error.toString());
    }
  }

  @protected
  Future<BaseMessageResponse> deleteUserList(
    DeleteUserListBody body, {
    required String url,
  }) async {
    _setIsUserListLoading = true;

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

      var messageResponse = decodedResponse.getBaseMessageResponse();

      if (messageResponse.error == null && _item != null) {
        _item!.userList = null;
        // Only notify listeners once for the combined change
        notifyListeners();
      }

      _setIsUserListLoading = false;
      return messageResponse;
    } catch (error) {
      _setIsUserListLoading = false;
      return BaseMessageResponse(error.toString(), error.toString());
    }
  }
}
