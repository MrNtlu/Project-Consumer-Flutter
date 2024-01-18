import 'package:flutter/cupertino.dart';

class SureDialog extends StatelessWidget {
  final String _text;
  final VoidCallback _onConfirm;

  const SureDialog(this._text, this._onConfirm, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Confirm"),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(_text),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text("Confirm"),
          onPressed: () {
            Navigator.pop(context);

            _onConfirm();
          },
        )
      ],
    );
  }
}
