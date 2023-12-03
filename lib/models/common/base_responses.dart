import 'package:watchlistfy/utils/type_converter.dart';

class BaseMessageResponse {
  final String? message;
  final String? error;

  const BaseMessageResponse(this.message, this.error);
}

class BaseNullableResponse<T> {
  late T? data;
  final String message;
  final String? error;

  BaseNullableResponse({
    Map<String, dynamic>? response,
    required this.message,
    this.error
  }){
    if (response != null) {
      var typeConverter = TypeConverter<T>();

      data = typeConverter.convertToObject(response);
    } else {
      data = null;
    }
  }
}

class BaseListResponse<T> {
  late List<T> data = [];
  final String? message;
  final int? code;
  final String? error;

  BaseListResponse({
    List<dynamic>? response,
    this.message,
    this.code,
    this.error
  }){
    if (response != null) {
      var typeConverter = TypeConverter<T>();
      
      response.map((e) {
        return e as Map<String, dynamic>; 
      }).forEach((element) { 
        data.add(typeConverter.convertToObject(element));
      });
    }
  }
}

class BasePaginationResponse<T> {
  late List<T> data = [];
  late bool canNextPage;
  final String? error;

  BasePaginationResponse({
    List<dynamic>? response,
    required this.canNextPage,
    this.error
  }){
    if (response != null) {
      var typeConverter = TypeConverter<T>();

      response.map((e){
        return e as Map<String, dynamic>;
      }).forEach((element) {
        data.add(typeConverter.convertToObject(element));
      });
    }
  }
}

class BaseNullablePaginationResponse<T> {
  late List<T>? data = [];
  late bool canNextPage;
  final String? error;

  BaseNullablePaginationResponse({
    List<dynamic>? response,
    required this.canNextPage,
    this.error
  }){
    if (response != null) {
      var typeConverter = TypeConverter<T>();

      response.map((e){
        return e as Map<String, dynamic>;
      }).forEach((element) {
        data!.add(typeConverter.convertToObject(element));
      });
    } else {
      data = null;
    }
  }
}

class BasePreviewResponse<T> {
  late List<T> upcoming = [];
  late List<T> popular = [];
  late List<T> top = [];
  late List<T>? extra = [];

  BasePreviewResponse({
    List<dynamic>? upcomingResponse,
    List<dynamic>? popularResponse,
    List<dynamic>? topResponse,
    List<dynamic>? extraResponse,
  }) {
    if (upcomingResponse != null) {
      var typeConverter = TypeConverter<T>();

      upcomingResponse.map((e){
        return e as Map<String, dynamic>;
      }).forEach((element) {
        upcoming.add(typeConverter.convertToObject(element));
      });
    }

    if (popularResponse != null) {
      var typeConverter = TypeConverter<T>();

      popularResponse.map((e){
        return e as Map<String, dynamic>;
      }).forEach((element) {
        popular.add(typeConverter.convertToObject(element));
      });
    }

    if (topResponse != null) {
      var typeConverter = TypeConverter<T>();

      topResponse.map((e){
        return e as Map<String, dynamic>;
      }).forEach((element) {
        top.add(typeConverter.convertToObject(element));
      });
    }

    if (extraResponse != null) {
      var typeConverter = TypeConverter<T>();

      extraResponse.map((e){
        return e as Map<String, dynamic>;
      }).forEach((element) {
        extra!.add(typeConverter.convertToObject(element));
      });
    } else {
      extra = null;
    }
  }
}