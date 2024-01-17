import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/providers/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  final VoidCallback onToggle;

  const ThemeSwitch(this.onToggle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SettingsTile.switchTile(
      onToggle: (_) {
        themeProvider.toggleTheme();
        onToggle();
      },
      initialValue: themeProvider.isDarkTheme,
      leading: const Icon(CupertinoIcons.moon_fill),
      title: const Text('Dark Theme'),
    );
  }
}
