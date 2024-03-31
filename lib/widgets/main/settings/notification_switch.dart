import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';

// ignore: must_be_immutable
class NotificationSwitch extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  bool value;

  NotificationSwitch(
    this.title,
    this.description,
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
      title: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              widget.title,
              minFontSize: 13,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 3),
            AutoSizeText(
              widget.description,
              minFontSize: 10,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 11,
                color: CupertinoColors.systemGrey
              ),
            ),
          ],
        ),
      )
    );
  }
}