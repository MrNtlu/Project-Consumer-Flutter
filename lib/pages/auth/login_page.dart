import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/pages/auth/register_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/google_signin_api.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/auth/email_field.dart';
import 'package:watchlistfy/widgets/auth/forgot_password_sheet.dart';
import 'package:watchlistfy/widgets/auth/or_with_line.dart';
import 'package:watchlistfy/widgets/auth/password_field.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/login";
  final loginModel = Login('', '');
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  LoginPage({super.key});

  void _onLoginPressed(BuildContext context) {
    if (_emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) =>
            const ErrorDialog("Please don't leave anything empty."),
      );
      return;
    } else if (!_emailTextController.text.isEmailValid()) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => const ErrorDialog("Invalid email address."),
      );
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (_) => const LoadingDialog(),
    );

    loginModel.emailAddress = _emailTextController.text.trim();
    loginModel.password = _passwordTextController.text;

    loginModel.login().then((value) {
      if (context.mounted) {
        Navigator.pop(context);

        if (value.message == null) {
          SharedPref().setTokenCredentials(value.token ?? '');

          context.pushReplacement("/");
        } else {
          showCupertinoDialog(
            context: context,
            builder: (_) => ErrorDialog(value.message ?? "Unknown error."),
          );

          if (value.code != null && value.code == 401) {
            loginModel.emailAddress = '';
            loginModel.password = '';
            SharedPref().deleteTokenCredentials();
          }
        }
      }
    });
  }

  void _onOAuth2GoogleLogin(BuildContext context, String idToken) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      var response = await http.post(Uri.parse(APIRoutes().oauthRoutes.google),
          body: json.encode({
            "token": idToken,
            "image": Constants.ProfileImageList[
                Random().nextInt(Constants.ProfileImageList.length - 1)],
            "fcm_token": fcmToken
          }),
          headers: {
            "Content-Type": "application/json",
          });

      final accessToken = json.decode(response.body)["access_token"];
      final message = json.decode(response.body)["message"];
      final error = json.decode(response.body)["error"];

      if (context.mounted) {
        Navigator.pop(context);

        if (accessToken == null) {
          SharedPref().deleteTokenCredentials();
          GoogleSignInApi().signOut();
          showCupertinoDialog(
              context: context, builder: (_) => ErrorDialog(error ?? message));
        } else {
          SharedPref().setTokenCredentials(accessToken ?? '');

          context.pushReplacement("/");
        }
      }
    } catch (err) {
      if (context.mounted) {
        Navigator.pop(context);
        showCupertinoDialog(
            context: context, builder: (_) => ErrorDialog(err.toString()));
      }
    }
  }

  Future _authenticate(BuildContext context, GoogleSignInAccount user) async {
    user.authentication.then((response) {
      if (context.mounted) {
        if (response.idToken != null) {
          _onOAuth2GoogleLogin(context, response.idToken!);
        } else {
          Navigator.pop(context);
          showCupertinoDialog(
              context: context,
              builder: (_) => const ErrorDialog("Failed to login!"));
        }
      }
    }).catchError((err) {
      if (context.mounted) {
        Navigator.pop(context);
        showCupertinoDialog(
            context: context, builder: (_) => ErrorDialog(err.toString()));
      }
    });
  }

  Future _onGoogleSignInPressed(BuildContext context) async {
    GoogleSignIn(clientId: dotenv.env['GOOGLE_CLIENT_KEY'])
        .signIn()
        .then((response) {
      if (context.mounted) {
        if (response != null) {
          _authenticate(context, response);
        } else {
          Navigator.pop(context);
        }
      }
    }).catchError((err) {
      if (context.mounted) {
        Navigator.pop(context);
        showCupertinoDialog(
            context: context, builder: (_) => ErrorDialog(err.toString()));
      }
    });
  }

  void _onOAuth2AppleLogin(BuildContext context, String code) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      var response = await http.post(Uri.parse(APIRoutes().oauthRoutes.apple),
          body: json.encode({
            "code": code,
            "is_refresh": false,
            "image": Constants.ProfileImageList[
                Random().nextInt(Constants.ProfileImageList.length - 1)],
            "fcm_token": fcmToken
          }),
          headers: {
            "Content-Type": "application/json",
          });

      final token = json.decode(response.body)["access_token"];
      final message = json.decode(response.body)["message"];
      final error = json.decode(response.body)["error"];
      // final refreshToken = json.decode(response.body)["refresh_token"];

      if (context.mounted) {
        Navigator.pop(context);

        if (token == null) {
          SharedPref().deleteTokenCredentials();
          showCupertinoDialog(
              context: context, builder: (_) => ErrorDialog(error ?? message));
        } else {
          SharedPref().setTokenCredentials(token ?? '');

          context.pushReplacement("/");
        }
      }
    } catch (err) {
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (_) => ErrorDialog(err.toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final mediaQuery = MediaQuery.sizeOf(context);
    final screenHeight = mediaQuery.height;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: const Text(
          "Welcome Back 👋",
          style: TextStyle(fontSize: 20),
        ),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),
                    Image.asset(
                      "assets/images/logo.png",
                      height: screenHeight > 400 ? screenHeight * 0.125 : 110,
                    ),
                    const SizedBox(height: 16),
                    EmailField(_emailTextController),
                    const SizedBox(height: 16),
                    PasswordField(_passwordTextController),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        minSize: 0,
                        padding: const EdgeInsets.all(3),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        onPressed: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            barrierColor:
                                CupertinoColors.black.withValues(alpha: 0.75),
                            builder: (_) => const ForgotPasswordSheet(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 6,
                        ),
                        color: AppColors().primaryColor,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          _onLoginPressed(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const OrWithLine(),
                    const SizedBox(height: 12),
                    if (Platform.isIOS || Platform.isMacOS) ...[
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 6,
                          ),
                          color: cupertinoTheme.bgTextColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.apple,
                                  color: cupertinoTheme.bgColor,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Sign in with Apple",
                                    style: TextStyle(
                                      color: cupertinoTheme.bgColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          onPressed: () async {
                            showCupertinoDialog(
                                context: context,
                                builder: (_) => const LoadingDialog());

                            try {
                              final credential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                ],
                              );

                              if (context.mounted) {
                                _onOAuth2AppleLogin(
                                    context, credential.authorizationCode);
                              }
                            } catch (_) {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (Platform.isAndroid)
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 6,
                          ),
                          color: Colors.white,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          onPressed: () async {
                            showCupertinoDialog(
                                context: context,
                                builder: (_) => const LoadingDialog());

                            try {
                              if (context.mounted) {
                                _onGoogleSignInPressed(context);
                              }
                            } catch (_) {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(builder: (_) {
                                return const RegisterPage();
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
