import 'dart:convert';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:watchlistfy/models/common/preview_response.dart';

extension DateTimeExt on DateTime {
  String dateToDaysAgo() {
    final dayDiff = DateTime.now().difference(this).inDays;
    final days = (dayDiff % 30);
    final months = (dayDiff / 30).floor();
    final years = (dayDiff / 365).floor();

    if (dayDiff >= 30 && dayDiff < 365) {
      if (dayDiff % 30 != 0) {
        return ("${months.dateDifferencePluralString('month')} ${days.dateDifferencePluralString('day')} ago.");
      }
      return ("$months months ago.");

    } else if (dayDiff >= 365) {
      if ((dayDiff - 365) / 30 != 0) {
        final months = ((dayDiff - 365) / 30).floor();
        return ("${years.dateDifferencePluralString('year')} ${months.dateDifferencePluralString('month')} ago.");
      }

      return ("${years.dateDifferencePluralString('year')} ago.");
    }

    if (dayDiff == 0) {
      return 'Today';
    } else if (dayDiff == 1) {
      return "Yesterday";
    }
    return '${dayDiff.dateDifferencePluralString('day')} ago.';
  }

  String dateToTime() {
    final DateFormat formatter = DateFormat("HH:mm");
    return formatter.format(this);
  }

  String dateToFormatDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }

  String dateToHumanDate() {
    final DateFormat formatter = DateFormat('dd MMM yy');
    return formatter.format(this);
  }

  String dateToDateTime() {
    final DateFormat formatter = DateFormat("dd MMM HH:mm");
    return formatter.format(this);
  }

  String dateToFullDateTime() {
    final DateFormat formatter = DateFormat("dd MMM yy HH:mm");
    return formatter.format(this);
  }

  String dateToJSONFormat() {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    return formatter.format(this);
  }

  String dateToSimpleJSONFormat() {
    final DateFormat formatter = DateFormat("yyyy-MM-dd");
    return formatter.format(this);
  }
}

extension IntExt on int {
  String dateDifferencePluralString(String text) {
    return '${toString()} ${this > 1 ? '${text}s' : text}';
  }

  String toLength() {
    if (this > 10) {
      final int hours = this ~/ 60;
      final minutes = this % 60;
      return "${hours}h ${minutes}m";
    } else {
      return toString();
    }
  }
}

extension StringExt on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool isEmailValid() {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }
}

extension DynamicMapExt on Map<String, dynamic> {
  Preview getPreviewResponse() => Preview(
    movieResponse: this["movie"],
    tvResponse: this["tv"],
    animeResponse: this["anime"],
    gameResponse: this["game"],
    error: this["error"]
  );

  BaseMessageResponse getBaseMessageResponse() => BaseMessageResponse(
    this["message"],
    this["error"],
  );

  BasePaginationResponse<T> getBasePaginationResponse<T>() => BasePaginationResponse(
    response: this["data"],
    canNextPage: (this["pagination"]?["next"] ?? 0) > 0,
    error: this["error"],
  );

  BaseNullableResponse<T> getBaseItemResponse<T>() => BaseNullableResponse<T>(
    message: this["message"] ?? '',
    error: this["error"],
    response: this["data"],
  );

  BaseListResponse<T> getBaseListResponse<T>() => BaseListResponse<T>(
    message: this["message"],
    response: this["data"],
    code: this["code"],
    error: this["error"]
  );

  BaseSuggestion<T> getBaseSuggestion<T>() => BaseSuggestion<T>(
    message: this["message"],
    response: this["data"] != null ? this["data"]["suggestions"] : [],
    createdAt: this["data"] != null ? this["data"]["created_at"] : null,
    code: this["code"],
    error: this["error"]
  );

  BaseAIResponse getAIResponse() => BaseAIResponse(
    data: this["data"] ?? '',
    message: this["message"],
    code: this["code"],
    error: this["error"],
  );
}

extension ResponseExt on Response {
  Preview getPreviewResponse() => Preview(
    movieResponse: json.decode(body)["movie"],
    tvResponse: json.decode(body)["tv"],
    animeResponse: json.decode(body)["anime"],
    gameResponse: json.decode(body)["game"],
    error: json.decode(body)["error"]
  );

  BaseMessageResponse getBaseMessageResponse() => BaseMessageResponse(
    json.decode(body)["message"],
    json.decode(body)["error"],
  );

  BaseNullableResponse<T> getBaseItemResponse<T>() => BaseNullableResponse<T>(
    message: json.decode(body)["message"] ?? '',
    error: json.decode(body)["error"],
    response: json.decode(body)["data"],
  );

  BaseListResponse<T> getBaseListResponse<T>() => BaseListResponse<T>(
    message: json.decode(body)["message"],
    response: json.decode(body)["data"],
    code: json.decode(body)["code"],
    error: json.decode(body)["error"]
  );

  BasePaginationResponse<T> getBasePaginationResponse<T>() => BasePaginationResponse(
    response: json.decode(body)["data"],
    canNextPage: (json.decode(body)["pagination"]?["next"] ?? 0) > 0,
    error: json.decode(body)["error"],
  );

  BaseNullablePaginationResponse<T> getBaseNullablePaginationResponse<T>() => BaseNullablePaginationResponse(
    response: json.decode(body)["data"],
    canNextPage: (json.decode(body)["pagination"]?["next"] ?? 0) > 0,
    error: json.decode(body)["error"],
  );
}