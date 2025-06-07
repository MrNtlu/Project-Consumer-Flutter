import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class SureDialog extends StatelessWidget {
  final String _text;
  final VoidCallback _onConfirm;

  const SureDialog(this._text, this._onConfirm, {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Platform.isAndroid
        ? AlertDialog(
            backgroundColor: cupertinoTheme.onBgColor,
            title: Text(
              "Confirm",
              style: TextStyle(color: cupertinoTheme.bgTextColor),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _text,
                style: TextStyle(color: cupertinoTheme.bgTextColor),
              ),
            ),
            actions: [
              TextButton(
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Confirm",
                    style: TextStyle(color: cupertinoTheme.primaryColor)),
                onPressed: () {
                  Navigator.pop(context);

                  _onConfirm();
                },
              )
            ],
          )
        : CupertinoAlertDialog(
            title: const Text("Confirm"),
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_text),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("Confirm"),
                onPressed: () {
                  Navigator.pop(context);

                  _onConfirm();
                },
              ),
            ],
          );
  }
}
