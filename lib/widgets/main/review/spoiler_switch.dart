import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

// ignore: must_be_immutable
class SpoilerSwitch extends StatefulWidget {
  bool isSpoiler;

  SpoilerSwitch({this.isSpoiler = false, super.key});

  @override
  State<SpoilerSwitch> createState() => _SpoilerSwitchState();
}

class _SpoilerSwitchState extends State<SpoilerSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoSwitch(
          activeColor: CupertinoTheme.of(context).bgTextColor,
          thumbColor: AppColors().primaryColor,
          value: widget.isSpoiler,
          onChanged: (value) {
            setState(() {
              widget.isSpoiler = !widget.isSpoiler;
            });
          },
        ),
        const Text("Contains Spoiler", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
      ],
    );
  }
}
