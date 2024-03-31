import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/pages/main/settings/settings_feedback_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class FeedbackDialog extends StatelessWidget {
  const FeedbackDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
    ? AlertDialog(
      backgroundColor: CupertinoTheme.of(context).onBgColor,
      title: Text(
        'Help Please 🥺',
        style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          "Can you take the survey and help us? It won't take longer than a minute!",
          style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
      ),
      actions: [
        TextButton(
          child: const Text("Don't show again!", style: TextStyle(color: Colors.grey, fontSize: 12)),
          onPressed: () {
           SharedPref().setCanShowFeedbackDialog(false);
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Take the Survey 📋', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            SharedPref().setCanShowFeedbackDialog(false);

            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const SettingsFeedbackPage();
              })
            );
          },
        )
      ],
    )
    : CupertinoAlertDialog(
      title: const Text('Would you like to help us? 🥺'),
      content: const Text("Can you take the survey and help us? It won't take longer than a minute!"),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            SharedPref().setCanShowFeedbackDialog(false);
            Navigator.pop(context);
          },
          child: const Text("Don't show again!"),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            SharedPref().setCanShowFeedbackDialog(false);

            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const SettingsFeedbackPage();
              })
            );
          },
          child: const Text('Take the Survey 📋'),
        ),
      ],
    );
  }
}
