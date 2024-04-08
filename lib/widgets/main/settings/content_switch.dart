import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/constants.dart';

class ContentSwitch extends StatelessWidget {
  const ContentSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final isGrid = globalProvider.contentMode == Constants.ContentUIModes.first;

    return SettingsTile.switchTile(
      onToggle: (_) {
        globalProvider.setContentMode(
          isGrid
          ? Constants.ContentUIModes.last
          : Constants.ContentUIModes.first
        );
      },
      initialValue: isGrid,
      leading: Icon(isGrid ? Icons.grid_view_rounded : CupertinoIcons.list_bullet),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Content ${isGrid ? 'Grid' : 'List'} View',
            minFontSize: 13,
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 3),
          AutoSizeText(
            "Content layout will be ${isGrid ? 'grid' : 'list'} view.",
            minFontSize: 10,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              color: CupertinoColors.systemGrey
            ),
          ),
        ],
      )
    );
  }
}