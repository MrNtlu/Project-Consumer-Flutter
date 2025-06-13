// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/pages/auth/policy_page.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/auth/conditions_checkbox.dart';
import 'package:watchlistfy/widgets/auth/email_field.dart';
import 'package:watchlistfy/widgets/auth/or_with_line.dart';
import 'package:watchlistfy/widgets/auth/password_field.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/notification_overlay.dart';
import 'package:watchlistfy/widgets/common/profile_image_list.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isInit = false;

  final _registerModel = Register('', '', '', '', '');

  late final TextEditingController _emailTextController;
  late final TextEditingController _usernameTextController;
  late final TextEditingController _passwordTextController;
  late final ProfileImageList _profileImageList;
  final _termsCheckNotifier = ValueNotifier(false);

  void _onRegisterPressed() async {
    if (_termsCheckNotifier.value) {
      if (_emailTextController.text.isEmpty ||
          _passwordTextController.text.isEmpty ||
          _usernameTextController.text.isEmpty) {
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

      _registerModel.emailAddress = _emailTextController.text;
      _registerModel.password = _passwordTextController.text;
      _registerModel.username = _usernameTextController.text;
      _registerModel.image =
          Constants.ProfileImageList[_profileImageList.selectedIndex];

      String? token = await FirebaseMessaging.instance.getToken();
      _registerModel.fcmToken = token ?? '';

      _registerModel.register().then((value) {
        if (context.mounted) {
          Navigator.pop(context);

          if (value.error != null) {
            showCupertinoDialog(
              context: context,
              builder: (_) => ErrorDialog(value.error ?? value.message ?? ''),
            );
          } else {
            Navigator.pop(context);

            NotificationOverlay().show(
              context,
              title: "Account Created",
              message:
                  value.message ?? "You have been registered successfully!",
              isError: true,
            );
          }
        }
      }).catchError((error) {
        Navigator.pop(context);
        showCupertinoDialog(
          context: context,
          builder: (_) => ErrorDialog(error),
        );
      });
    } else {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => const ErrorDialog(
          "Please accept Terms & Conditions and Privacy Policy",
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _emailTextController = TextEditingController();
      _passwordTextController = TextEditingController();
      _usernameTextController = TextEditingController();
      _profileImageList = ProfileImageList();

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final marginBottom = mediaQuery.viewInsets.bottom;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Create Account",
          style: TextStyle(fontSize: 20),
        ),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.only(
              bottom: marginBottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                _profileImageList,
                const SizedBox(height: 16),
                EmailField(_emailTextController),
                const SizedBox(height: 16),
                EmailField(
                  _usernameTextController,
                  label: "Username",
                  prefixIcon: Icons.person_rounded,
                ),
                const SizedBox(height: 16),
                PasswordField(_passwordTextController),
                const SizedBox(height: 12),
                Material(
                  child: ConditionsCheckbox(
                    agreedNotifier: _termsCheckNotifier,
                    onTermsTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) {
                            return const PolicyPage(false);
                          },
                        ),
                      );
                    },
                    onPrivacyTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) {
                            return const PolicyPage(true);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      _onRegisterPressed();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const OrWithLine(text: 'or'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an Account?",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
