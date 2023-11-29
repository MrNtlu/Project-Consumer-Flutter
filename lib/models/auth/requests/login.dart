import 'dart:convert';

import 'package:watchlistfy/models/auth/responses/token.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/json_convert.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';

class Login implements JSONConverter {
  String emailAddress;
  String password;

  Login(this.emailAddress, this.password);

  Future<TokenResponse> login() async {
    try {
      var response = await http.post(
        Uri.parse(APIRoutes().authRoutes.login),
        body: json.encode(convertToJson()),
        headers: {
          "Content-Type": "application/json",
        }
      );

      return TokenResponse(
        code: json.decode(response.body)["code"],
        message: json.decode(response.body)["message"],
        token: json.decode(response.body)["access_token"],
      );
    } catch (error) {
      return TokenResponse(
        code: 400,
        message: error.toString()
      );
    }
  }

  @override
  Map<String, Object> convertToJson() => {
    "email_address": emailAddress,
    "password": password
  }; 
}

class Register implements JSONConverter {
  String emailAddress;
  String currency;
  String password;

  Register(this.emailAddress, this.currency, this.password);

  Future<BaseMessageResponse> register() async {
    try {
      var response = await http.post(
        Uri.parse(APIRoutes().authRoutes.register),
        body: json.encode(convertToJson()),
        headers: {
          "Content-Type": "application/json",
        }
      );

      return BaseMessageResponse(jsonDecode(response.body)["message"], jsonDecode(response.body)["error"]);
    } catch (error) {
      return BaseMessageResponse(error.toString(), null);
    }
  }

  @override
  Map<String, Object> convertToJson() => {
     "email_address": emailAddress, 
     "currency": currency,
     "password": password
  };
}

class ChangePassword {
  final String oldPassword;
  final String newPassword;

  const ChangePassword(this.oldPassword, this.newPassword);
}

class ForgotPassword {
  final String emailAddress;

  const ForgotPassword(this.emailAddress);
}