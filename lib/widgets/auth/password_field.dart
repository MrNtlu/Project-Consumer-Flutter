import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController _controller;
  final String label;

  const PasswordField(
    this._controller, {
    this.label = "Password",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> obscureTextNotifier = ValueNotifier(true);

    return ValueListenableBuilder<bool>(
        valueListenable: obscureTextNotifier,
        builder: (context, obscureText, child) {
          return CupertinoTextField(
            obscureText: obscureText,
            enableSuggestions: false,
            autocorrect: false,
            controller: _controller,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            maxLines: 1,
            prefix: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 16,
                bottom: 16,
                right: 12,
              ),
              child: Icon(
                Icons.lock_rounded,
                color: CupertinoTheme.of(context).bgTextColor,
              ),
            ),
            suffix: CupertinoButton(
              child: Icon(
                obscureText
                    ? CupertinoIcons.eye_slash_fill
                    : CupertinoIcons.eye_fill,
              ),
              onPressed: () {
                obscureTextNotifier.value = !obscureText;
              },
            ),
            placeholder: "Enter Password",
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).onBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            style: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.all(8),
          );
        });
  }
}
