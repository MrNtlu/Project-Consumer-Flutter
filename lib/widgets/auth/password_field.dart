import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController _controller;

  const PasswordField(
    this._controller,
    {
      super.key
    }
  );

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      controller: widget._controller,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      maxLines: 1,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 12, top: 16, bottom: 16),
        child: SizedBox(
          width: 90,
          child: Text(
            "Password",
            style: TextStyle(
              color: CupertinoTheme.of(context).bgTextColor, 
              fontSize: 16
            ),
          ),
        ),
      ),
      suffix: CupertinoButton(
        child: Icon(obscureText ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
      ),
      placeholder: "Enter Password",
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).onBgColor,
        borderRadius: BorderRadius.circular(8)
      ),
      style: const TextStyle(fontSize: 16),
      padding: const EdgeInsets.all(8),
    );
  }
}