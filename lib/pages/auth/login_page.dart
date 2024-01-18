import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/pages/auth/register_page.dart';
import 'package:watchlistfy/pages/tabs_page.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/auth/email_field.dart';
import 'package:watchlistfy/widgets/auth/forgot_password_sheet.dart';
import 'package:watchlistfy/widgets/auth/password_field.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/login";
  final loginModel = Login('', '');
  late final TextEditingController _emailTextController;
  late final TextEditingController _passwordTextController;

  LoginPage({super.key});

  /*
  * Implement Google signin
  * Implement Apple Signin also to backend
  * https://github.com/MrNtlu/Asset-Manager-Flutter/blob/master/lib/auth/pages/login_page.dart
  */

  void _onLoginPressed(BuildContext context) {
    if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
      showCupertinoDialog(
        context: context, 
        builder: (ctx) => const ErrorDialog("Please don't leave anything empty.")
      );
      return;
    } else if (!_emailTextController.text.isEmailValid()) {
      showCupertinoDialog(
        context: context, 
        builder: (ctx) => const ErrorDialog("Invalid email address.")
      );
      return;
    }
    
    showCupertinoDialog(context: context, builder: (_) => const LoadingDialog());

    loginModel.emailAddress = _emailTextController.text;
    loginModel.password = _passwordTextController.text;

    loginModel.login().then((value) {
      Navigator.pop(context);

      if (value.message == null) {
        SharedPref().setTokenCredentials(value.token ?? '');

        Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (_) {
          return const TabsPage();
        }), (_) => false);
      } else {
        showCupertinoDialog(context: context, builder: (_) => ErrorDialog(value.message ?? "Unknown error."));

        if (value.code != null && value.code == 401) {
          loginModel.emailAddress = '';
          loginModel.password = '';
          SharedPref().deleteTokenCredentials();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();

    return CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(
              largeTitle: Text("Welcome Back", style: TextStyle(fontSize: 24)),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmailField(_emailTextController),
                      const SizedBox(height: 24),
                      PasswordField(_passwordTextController),
                      const SizedBox(height: 32),
                      CupertinoButton.filled(
                        child: const Text(
                          "Login",
                          style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        onPressed: () {
                          _onLoginPressed(context);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an Account?", style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 6),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Text(
                              "Register",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(builder: (_) {
                                  return const RegisterPage();
                                })
                              );
                            },
                          ),
                        ],
                      ),
                      CupertinoButton(
                        minSize: 0,
                        padding: const EdgeInsets.all(3),
                        child: const Text("Forgot Password?", style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)), 
                        onPressed: (){
                          showCupertinoModalBottomSheet(
                            context: context,
                            barrierColor: CupertinoColors.black.withOpacity(0.75),
                            builder: (_) => const ForgotPasswordSheet()
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
