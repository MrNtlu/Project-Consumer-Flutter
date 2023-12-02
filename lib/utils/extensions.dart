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
}

extension StringExt on String {
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
}

extension ResponseExt on Response {
  //TODO Remove later, example
  // static Preview getPreviewResponseStatic(String responseBody) {
  //   return Preview.fromJson(json.decode(responseBody));
  // }
  
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