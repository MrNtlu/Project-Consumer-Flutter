import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);
    final cupertinoTheme = CupertinoTheme.of(context);

    return GestureDetector(
      onTap: () {
        if (!authenticationProvider.isAuthenticated) {
          Navigator.of(context, rootNavigator: true)
              .push(CupertinoPageRoute(builder: (_) {
            return LoginPage();
          }));
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Card(
          color: cupertinoTheme.bgColor,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: CupertinoColors.systemBlue, width: 1.0),
              borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(
              child: AutoSizeText(
                minFontSize: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                authenticationProvider.isAuthenticated
                    ? "Press and hold your username for quick menu."
                    : "Login or Register now to access all features.",
                style: TextStyle(
                  color: cupertinoTheme.bgTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
