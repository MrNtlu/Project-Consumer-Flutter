import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

// ignore: must_be_immutable
class CustomListPrivateSwitch extends StatefulWidget {
  bool isPrivate;

  CustomListPrivateSwitch({this.isPrivate = false, super.key});

  @override
  State<CustomListPrivateSwitch> createState() => _CustomListPrivateSwitchState();
}

class _CustomListPrivateSwitchState extends State<CustomListPrivateSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoSwitch(
          activeColor: CupertinoTheme.of(context).bgTextColor,
          thumbColor: AppColors().primaryColor,
          value: !widget.isPrivate,
          onChanged: (value) {
            setState(() {
              widget.isPrivate = !widget.isPrivate;
            });
          },
        ),
        const Spacer(),
        Text(widget.isPrivate ? "Private" : "Public", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        const SizedBox(width: 6),
        Text(widget.isPrivate ? "Only you can see it." : "Everybody can see it.", style: const TextStyle(color: CupertinoColors.systemGrey2, fontSize: 12)),
      ],
    );
  }
}