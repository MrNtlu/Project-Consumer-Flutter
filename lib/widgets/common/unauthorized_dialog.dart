import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';

class UnauthorizedDialog extends StatelessWidget {
  const UnauthorizedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Unauthorized Access'),
      content: const Text('You need to login to do this action.'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return LoginPage();
              })
            );
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
