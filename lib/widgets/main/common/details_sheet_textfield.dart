import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class DetailsSheetTextfield extends StatelessWidget {
  final TextEditingController _controller;
  final String text;
  final VoidCallback onPressed;

  const DetailsSheetTextfield(
    this._controller, {required this.text, required this.onPressed, super.key}
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      maxLines: 1,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          text,
          style: TextStyle(color: CupertinoTheme.of(context).bgTextColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      textAlign: TextAlign.end,
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).bgColor,
        borderRadius: BorderRadius.circular(8)
      ),
      style: const TextStyle(fontSize: 16),
      padding: const EdgeInsets.all(8),
      suffix: CupertinoButton(
        onPressed: onPressed,
        child: Icon(Icons.add_circle_rounded, color: CupertinoTheme.of(context).bgTextColor,), 
      ),
    );
  }
}