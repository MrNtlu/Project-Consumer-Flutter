import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// ignore: must_be_immutable
class NotificationSwitch extends StatefulWidget {
  final String title;
  final IconData icon;
  bool value;

  NotificationSwitch(
    this.title,
    this.icon,
    {
      this.value = false,
      super.key
    }
  );

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {

  @override
  Widget build(BuildContext context) {
    return SettingsTile.switchTile(
      onToggle: (value) {
        setState(() {
          widget.value = value;
        });
      },
      initialValue: widget.value,
      leading: Icon(widget.icon),
      title: AutoSizeText(
        widget.title,
        minFontSize: 13,
        maxLines: 1,
        textAlign: TextAlign.start,
      )
    );
  }
}