import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/auth/email_field.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/widgets/common/message_dialog.dart';

class ForgotPasswordSheet extends StatelessWidget {
  const ForgotPasswordSheet({super.key});

  void onSendEmailPressed(BuildContext context, String email) async {
    final isValid = email.isNotEmpty && email.isEmailValid();
    if (!isValid) {
      showCupertinoDialog(
          context: context,
          builder: (_) => const ErrorDialog("Invalid email address."));
      return;
    }

    showCupertinoDialog(
        context: context, builder: (_) => const LoadingDialog());

    try {
      final response = await http.post(
        Uri.parse(APIRoutes().userRoutes.forgotPassword),
        body: json.encode({
          "email_address": email,
        }),
      );
      if (context.mounted) {
        Navigator.pop(context);

        if (response.getBaseMessageResponse().error != null) {
          showCupertinoDialog(
              context: context,
              builder: (ctx) =>
                  ErrorDialog(response.getBaseMessageResponse().error!));
          return;
        }

        Navigator.pop(context);

        showCupertinoDialog(
            context: context,
            builder: (ctx) => MessageDialog(response
                    .getBaseMessageResponse()
                    .message ??
                "Please check your inbox. Don't forget to check your spams too."));
      }
    } catch (error) {
      if (context.mounted) {
        showCupertinoDialog(
            context: context, builder: (ctx) => ErrorDialog(error.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailTextEditingController = TextEditingController();
    final cupertinoTheme = CupertinoTheme.of(context);

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.all(12),
        color: cupertinoTheme.bgColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmailField(emailTextEditingController),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: const Text(
                "Please enter your email address. You'll receive password reset email if you have an account.",
                softWrap: true,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
              ),
            ),
            CupertinoButton.filled(
              child: const Text(
                "Send Mail",
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                onSendEmailPressed(context, emailTextEditingController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
