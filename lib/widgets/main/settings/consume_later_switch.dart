import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/constants.dart';

class ConsumeLaterSwitch extends StatelessWidget {
  const ConsumeLaterSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final isGrid = globalProvider.consumeLaterMode == Constants.ConsumeLaterUIModes.first;

    return SettingsTile.switchTile(
      onToggle: (_) {
        globalProvider.setConsumeLaterMode(
          isGrid
          ? Constants.ConsumeLaterUIModes.last
          : Constants.ConsumeLaterUIModes.first
        );
      },
      initialValue: isGrid,
      leading: Icon(isGrid ? Icons.grid_view_rounded : CupertinoIcons.list_bullet),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Watch Later ${isGrid ? 'Grid' : 'List'} View',
            minFontSize: 13,
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 3),
          AutoSizeText(
            "Watch later layout will be ${isGrid ? 'grid' : 'list'} view.",
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