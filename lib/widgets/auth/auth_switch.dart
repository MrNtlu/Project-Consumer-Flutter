import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/pages/auth/policy_page.dart';
import 'package:watchlistfy/static/colors.dart';

// ignore: must_be_immutable
class AuthSwitch extends StatefulWidget {
  final String title;
  final bool isPrivacyPolicy;

  bool _value = false;
  bool getValue() => _value;

  // ignore: use_key_in_widget_constructors
  AuthSwitch(this.title, this.isPrivacyPolicy);

  @override
  State<AuthSwitch> createState() => _AuthSwitchState();
}

class _AuthSwitchState extends State<AuthSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, 
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CupertinoSwitch(
            activeColor: CupertinoTheme.of(context).bgTextColor,
            thumbColor: AppColors().primaryColor,
            value: widget._value,
            onChanged: (value) {
              setState(() {
                widget._value = !widget._value;
              });
            },
          ),
        ),
        CupertinoButton(
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 14, color: CupertinoColors.systemBlue),
          ),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (_) {
                return PolicyPage(widget.isPrivacyPolicy);
              })
            );
          },
        ),
      ]
    );
  }
}