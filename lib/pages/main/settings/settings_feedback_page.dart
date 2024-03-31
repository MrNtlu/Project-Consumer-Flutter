import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';

class SettingsFeedbackPage extends StatelessWidget {
  const SettingsFeedbackPage({super.key});

  void _sendFeedback(
    BuildContext context,
    List<QuestionResult> results
  ) {
    showCupertinoDialog(
      context: context,
      builder: (_) => const LoadingDialog()
    );

    try {
      String feedback = '';
      for (QuestionResult result in results) {
        feedback += "Q: ${result.question}\n";
        feedback += "A: ${result.answers.first}\n\n";
        if (result.children.isNotEmpty) {
          final extraQuestion = result.children.first;
          feedback += "Extra Q: ${extraQuestion.question}\n";
          feedback += "Extra A: ${extraQuestion.answers.first}\n\n";
        }
      }

      http.patch(
        Uri.parse(APIRoutes().userRoutes.feedbackURL),
        headers: UserToken().getBearerToken(),
        body: json.encode({
          "feedback": feedback,
        }),
      ).then((response){
        Navigator.pop(context);

        final message = response.getBaseMessageResponse();
        if (message.error == null) {
          showCupertinoDialog(
            context: context,
            builder: (_) => const MessageDialog("Thank you for helping us with your valuable feedback 🙏")
          );
        } else {
          showCupertinoDialog(
            context: context,
            builder: (_) => ErrorDialog(message.error.toString())
          );
        }
      }).onError((error, stackTrace) {
        Navigator.pop(context);

        showCupertinoDialog(
          context: context,
          builder: (_) => ErrorDialog(error.toString())
        );
      });
    } catch(error) {
      Navigator.pop(context);

      showCupertinoDialog(
        context: context,
        builder: (_) => ErrorDialog(error.toString())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<QuestionResult> results = [];
    final formKey = GlobalKey<FormState>();

    final List<Question> initialData = [
      Question(
        isMandatory: true,
        question: 'How would you rate your experince so far?',
        singleChoice: true,
        answerChoices: {
          "Good 😁": null,
          "Okay 😊": null,
          "Bad 😒": [
            Question(
              question: "Can you tell us why?",
            )
          ],
        },
      ),
      Question(
        question: "How is the performance of the app? (Bugs, slow response etc.)",
        isMandatory: true,
        answerChoices: {
          "Perfect 👌": null,
          "Okay 😐": null,
          "Bad 😢": [
            Question(
              question: "What was the problem?",
            )
          ],
        }
      ),
      Question(
        question: "What would you like to see in the future, how can we improve the application?",
      ),
    ];
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("📋 Survey"),
      ),
      child: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Survey(
                  initialData: initialData,
                  onNext: (res) {
                    results = res;
                  },
                ),
              ),
              const SizedBox(height: 6),
              CupertinoButton.filled(
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _sendFeedback(context, results);
                  }
                }
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}