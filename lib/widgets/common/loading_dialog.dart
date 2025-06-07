import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Platform.isAndroid
        ? AlertDialog(
            backgroundColor: cupertinoTheme.onBgColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: cupertinoTheme.bgTextColor,
                ),
                const SizedBox(height: 12),
                Text(
                  "Please wait",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: cupertinoTheme.bgTextColor,
                  ),
                )
              ],
            ),
          )
        : CupertinoAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                  radius: 14,
                  color: cupertinoTheme.bgTextColor,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Please wait",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
  }
}
