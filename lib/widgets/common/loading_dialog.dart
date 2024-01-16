import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(radius: 14, color: CupertinoTheme.of(context).bgTextColor),
          const SizedBox(height: 12),
          const Text(
            "Please wait", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          )
        ],
      ),
    );
  }
}