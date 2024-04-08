import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/constants.dart';

class UserListSwitch extends StatelessWidget {
  const UserListSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final isExpanded = globalProvider.userListMode == Constants.UserListUIModes.first;

    return SettingsTile.switchTile(
      onToggle: (_) {
        globalProvider.setUserListMode(
          isExpanded
          ? Constants.UserListUIModes[1]
          : Constants.UserListUIModes.first
        );
      },
      initialValue: isExpanded,
      leading: Icon(isExpanded ? Icons.expand_rounded : Icons.compress_rounded),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'User List ${isExpanded ? 'Expanded' : 'Compact'}',
            minFontSize: 13,
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 3),
          AutoSizeText(
            "User list layout will be ${isExpanded ? 'expanded' : 'compact'}.",
            minFontSize: 10,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              color: CupertinoColors.systemGrey
            ),
          ),
        ],
      ),
    );
  }
}