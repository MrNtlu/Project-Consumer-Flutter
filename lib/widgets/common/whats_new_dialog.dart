import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class WhatsNewDialog extends StatelessWidget {
  const WhatsNewDialog({super.key});

  final String patchNotes = """
Major Improvements & QoL Improvements 🎉

- Discover new filter added.
  - Popular Studios and Publishers added to filters.
- Popular Studios QoL improvements.
- Login page design improved.
- Popular Publishers added.
- Discover, result count added.
- Settings, usage and limit info added.
- Survey page bug fixed.
- Survey page improvements.
- Home page header improved.
- User list improvements.
  """;

  final String version = "1.6.4";

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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.4
          ),
          child: SingleChildScrollView(
            child: UnconstrainedBox(
              constrainedAxis: Axis.horizontal,
              child: Text(
                patchNotes,
                style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
            ),
          ),
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