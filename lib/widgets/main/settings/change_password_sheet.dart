import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/auth/password_field.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/widgets/common/message_dialog.dart';

class ChangePasswordSheet extends StatelessWidget {
  const ChangePasswordSheet({super.key});

  void onChangePasswordPressed(BuildContext context, String oldPassword, String newPassword) async {
    final isValid = newPassword.isNotEmpty && newPassword.length > 5 && oldPassword.isNotEmpty;
    if (!isValid) {
      showCupertinoDialog(context: context, builder: (_) => const ErrorDialog("Invalid password."));
      return;
    }
    
    try {
      showCupertinoModalBottomSheet(
        context: context, 
        builder: (_) => const LoadingDialog()
      );

      final response = await http.patch(
        Uri.parse(APIRoutes().userRoutes.changePassword),
        headers: UserToken().getBearerToken(),
        body: json.encode({
          "new_password": newPassword,
          "old_password": oldPassword
        }),
      );

      if (context.mounted) {
        Navigator.pop(context);

        if (response.getBaseMessageResponse().error != null){          
          showCupertinoDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.getBaseMessageResponse().error!)
          ); 
          return;
        }
        
        showCupertinoDialog(
          context: context, 
          builder: (ctx) => MessageDialog(response.getBaseMessageResponse().message ?? "Password changed successfully.")
        );
      }
    } catch(error) {
      if (context.mounted) {
        Navigator.pop(context);

        showCupertinoDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(error.toString())
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final oldPasswordTextEditingController = TextEditingController();
    final newPasswordTextEditingController = TextEditingController();

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.all(12),
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PasswordField(
              oldPasswordTextEditingController,
              label: "Old Password",
            ),
            PasswordField(
              newPasswordTextEditingController,
              label: "New Password",
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: const Text(
                "Please enter your new password with caution!",
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey2
                ),
              )
            ),
            CupertinoButton.filled(
              child: const Text("Change Password", style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
              onPressed: () {
                onChangePasswordPressed(
                  context, 
                  oldPasswordTextEditingController.text,
                  newPasswordTextEditingController.text,
                );
              }
            )
          ],
        ),
      ),
    );
  }
}