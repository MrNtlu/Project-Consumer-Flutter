import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  const MessageDialog(this.message, {this.title = "Success", super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
    ? AlertDialog(
      backgroundColor: CupertinoTheme.of(context).onBgColor,
      title: Text(title, style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(message, style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
      ),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context); }, child: const Text("OK", style: TextStyle(color: Colors.red)))
      ],
    )
    : CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
