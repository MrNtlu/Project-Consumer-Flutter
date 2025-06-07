import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class ErrorDialog extends StatelessWidget {
  final String _error;

  const ErrorDialog(this._error, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Platform.isAndroid
        ? AlertDialog(
            backgroundColor: cupertinoTheme.onBgColor,
            title: Text(
              "Error",
              style: TextStyle(color: cupertinoTheme.bgTextColor),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _error,
                style: TextStyle(
                  color: cupertinoTheme.bgTextColor,
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Gotcha!",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        : CupertinoAlertDialog(
            title: const Text("Error"),
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("Gotcha!"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
  }
}
