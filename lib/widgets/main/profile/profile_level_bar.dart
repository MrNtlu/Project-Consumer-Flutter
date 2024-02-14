import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';

class ProfileLevelBar extends StatelessWidget {
  final int level;
  const ProfileLevelBar(this.level, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 24),
          SizedBox(
            width: 150,
            child: LinearProgressIndicator(
              value: level.toDouble() / 100,
              minHeight: 6,
              backgroundColor: CupertinoTheme.of(context).onBgColor,
              color: AppColors().primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "$level Lvl",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (_) => const MessageDialog(
                  "Level is calculated based on User List, Watch Later, Reviews and Lists.",
                  title: "Information",
                )
              );
            },
            child: const Icon(CupertinoIcons.info_circle, size: 17),
          )
        ],
      ),
    );
  }
}