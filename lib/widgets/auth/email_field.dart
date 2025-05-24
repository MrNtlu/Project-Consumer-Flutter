import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class EmailField extends StatelessWidget {
  final TextEditingController _controller;
  final IconData prefixIcon;
  final String label;

  const EmailField(
    this._controller, {
    this.label = "Email",
    this.prefixIcon = Icons.email_rounded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: _controller,
      textInputAction: TextInputAction.next,
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
          prefixIcon,
          color: CupertinoTheme.of(context).bgTextColor,
        ),
      ),
      placeholder: "Enter $label",
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).onBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      style: const TextStyle(fontSize: 16),
      padding: const EdgeInsets.all(8),
    );
  }
}
