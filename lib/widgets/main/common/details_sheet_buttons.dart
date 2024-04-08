import 'package:flutter/cupertino.dart';

class DetailsSheetButtons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const DetailsSheetButtons({
    required this.text, required this.onPressed, super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CupertinoButton(
          child: const Text("Cancel", style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 14)), 
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        CupertinoButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold, fontSize: 16)
          ), 
        )
      ],
    );
  }
}