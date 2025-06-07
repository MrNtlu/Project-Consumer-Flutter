import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class WhatsNewDialog extends StatelessWidget {
  const WhatsNewDialog({super.key});

  final String patchNotes = """
New Features & QoL Improvements 🎉

- AI Recommendation fixed and improved.
- AI Recommendation consistency improved.
- Accidental adult content removed and fixed.
- Redesign started.
- UI changes.
- UI improvements.
- Performance improvements.
- Image performance improved.
- Premium prices decreased.
""";

  final String version = "1.7.0";

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final mediaQuery = MediaQuery.sizeOf(context);
    final height = mediaQuery.height * 0.4;

    return Platform.isAndroid
        ? AlertDialog(
            backgroundColor: cupertinoTheme.onBgColor,
            title: Text(
              "What's New (v$version)",
              style: TextStyle(
                color: cupertinoTheme.bgTextColor,
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height,
                ),
                child: SingleChildScrollView(
                  child: UnconstrainedBox(
                    constrainedAxis: Axis.horizontal,
                    child: Text(
                      patchNotes,
                      style: TextStyle(
                        color: cupertinoTheme.bgTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Don't show again!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  SharedPref().setShouldShowWhatsNewDialog(false);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text(
                  "OK!",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  SharedPref().setDidShowVersionPatch(true);
                  Navigator.pop(context);
                },
              )
            ],
          )
        : CupertinoAlertDialog(
            title: Text(
              "What's New (v$version",
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                patchNotes,
                textAlign: TextAlign.start,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text(
                  "Don't show again!",
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  SharedPref().setShouldShowWhatsNewDialog(false);
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("OK!"),
                onPressed: () {
                  SharedPref().setDidShowVersionPatch(true);
                  Navigator.pop(context);
                },
              )
            ],
          );
  }
}
