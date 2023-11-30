import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';

class AnonymousHeader extends StatelessWidget {
  const AnonymousHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: const Text(
        "Login/Register",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
      ), 
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(builder: (_) {
          return LoginPage();
        })
      ),
    );
  }
}