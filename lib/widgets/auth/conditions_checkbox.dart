import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class ConditionsCheckbox extends StatelessWidget {
  final ValueNotifier<bool> agreedNotifier;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const ConditionsCheckbox({
    super.key,
    required this.agreedNotifier,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: agreedNotifier,
          builder: (context, agreed, _) {
            return Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: agreed,
                onChanged: (value) {
                  agreedNotifier.value = value ?? false;
                },
                side: const BorderSide(color: CupertinoColors.inactiveGray),
                activeColor: CupertinoColors.systemBlue,
                checkColor: Colors.white,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          },
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: CupertinoTheme.of(context).bgTextColor,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(
                    color: CupertinoColors.systemBlue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: CupertinoColors.systemBlue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
