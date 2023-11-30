import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/pages/tabs_page.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/login";
  final form = GlobalKey<FormState>();
  final loginModel = Login('test@gmail.com', '123Test');

  void _onLoginPressed(BuildContext context, {Login? login}) {
    if (login == null) {
      final isValid = form.currentState?.validate();
      if (isValid != null && !isValid) {
        return;
      }
      form.currentState?.save();
    }

    var _login = login ?? loginModel;
    _login.login().then((value) {
      if (value.message == null) {
        print("Logged in ${value.token}");
        
        SharedPref().setTokenCredentials(value.token ?? '');

        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) {
          return const TabsPage();
        }));
      }
    });
  }

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Login"),
          previousPageTitle: "Home",
        ),
        child: CupertinoButton.filled(
          child: const Text(
            "Login",
            style: TextStyle(color: CupertinoColors.white),
          ),
          onPressed: () {
            _onLoginPressed(context);
          },
        ));
  }
}
