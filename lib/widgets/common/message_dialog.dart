import 'package:flutter/cupertino.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  const MessageDialog(this.message, {this.title = "Success", super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("OK 👍"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
