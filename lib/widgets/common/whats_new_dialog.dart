import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class WhatsNewDialog extends StatelessWidget {
  const WhatsNewDialog({super.key});

  final String patchNotes = """
Major UI Improvements 🎉

- Profile design changed.
- Content details design changed.
- Settings design changed.
- AI Recommendations moved to Profile.
- Recommendations page added.
- Recommendation bug fixes.
- User List bug fixed.
- Genre design improved.
- Pagination loading bug fixed.
- UI bug fixes.
  """;

  final String version = "1.6.1";

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
    ? AlertDialog(
      backgroundColor: CupertinoTheme.of(context).onBgColor,
      title: Text(
        "What's New (v$version)",
        style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Flexible(
          child: Text(
            patchNotes,
            style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Don't show again!", style: TextStyle(color: Colors.grey, fontSize: 12)),
          onPressed: () {
            SharedPref().setShouldShowWhatsNewDialog(false);
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("OK!", style: TextStyle(color: Colors.red)),
          onPressed: () {
            SharedPref().setDidShowVersionPatch(true);
            Navigator.pop(context);
          },
        )
      ],
    )
    : CupertinoAlertDialog(
      title: Text("What's New (v$version)"),
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
          child: const Text("Don't show again!", style: TextStyle(fontSize: 12)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text("OK!"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}