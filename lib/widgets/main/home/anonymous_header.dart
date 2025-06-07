import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';
import 'package:watchlistfy/static/colors.dart';

class AnonymousHeader extends StatelessWidget {
  const AnonymousHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.login_rounded,
            size: 22,
            color: AppColors().primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors().primaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
          builder: (_) {
            return LoginPage();
          },
        ),
      ),
    );
  }
}
