import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';
import 'package:watchlistfy/static/colors.dart';

class UnauthorizedDialog extends StatelessWidget {
  const UnauthorizedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
    ? AlertDialog(
      backgroundColor: CupertinoTheme.of(context).onBgColor,
      title: Text(
        'Unauthorized Access',
        style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          'You need to login to do this action.',
          style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 12)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("Login", style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return LoginPage();
              })
            );
          },
        )
      ],
    )
    : CupertinoAlertDialog(
      title: const Text('Unauthorized Access'),
      content: const Text('You need to login to do this action.'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return LoginPage();
              })
            );
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
