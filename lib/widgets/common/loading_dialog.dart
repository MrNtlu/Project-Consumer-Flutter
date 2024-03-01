import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
    ? AlertDialog(
      backgroundColor: CupertinoTheme.of(context).onBgColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: CupertinoTheme.of(context).bgTextColor),
          const SizedBox(height: 12),
          Text(
            "Please wait",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoTheme.of(context).bgTextColor),
          )
        ],
      ),
    )
    : CupertinoAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(radius: 14, color: CupertinoTheme.of(context).bgTextColor),
          const SizedBox(height: 12),
          const Text(
            "Please wait",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          )
        ],
      ),
    );
  }
}