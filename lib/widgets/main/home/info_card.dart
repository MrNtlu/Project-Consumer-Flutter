import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Card(
        color: CupertinoTheme.of(context).bgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: CupertinoTheme.of(context).primaryColor, width: 1.0),
          borderRadius: BorderRadius.circular(12)
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              authenticationProvider.isAuthenticated
              ? "Vote now and decide new features!"
              : "Login or Register now to access all features.",
              style: TextStyle(color: CupertinoTheme.of(context).bgTextColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}