import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/providers/theme_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/widgets/main/settings/theme_switch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DetailState _state = DetailState.init;
  String? error = null;
  UserInfo? _userInfo = null;

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.initTheme(SharedPref().isDarkTheme());
      // _getUserInfo();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Settings"),
        backgroundColor: CupertinoTheme.of(context).bgColor,
      ),
      child: SettingsList(
        darkTheme: SettingsThemeData(
          settingsListBackground: cupertinoTheme.bgColor,
          settingsSectionBackground: cupertinoTheme.onBgColor,
          titleTextColor: cupertinoTheme.bgTextColor,
          settingsTileTextColor: cupertinoTheme.bgTextColor,
        ),
        lightTheme: SettingsThemeData(
          settingsListBackground: cupertinoTheme.bgColor,
          settingsSectionBackground: cupertinoTheme.onBgColor,
          titleTextColor: cupertinoTheme.bgTextColor,
          settingsTileTextColor: cupertinoTheme.bgTextColor,
        ),
        platform: DevicePlatform.iOS,
        sections: const [
          SettingsSection(
            title: Text("Application"),
            tiles: [
              CustomSettingsTile(child: ThemeSwitch())
            ]
          )
        ],
      ),
    );
  }
}
