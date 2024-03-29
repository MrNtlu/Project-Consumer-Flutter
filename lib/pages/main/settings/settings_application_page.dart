import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/settings/consume_later_switch.dart';
import 'package:watchlistfy/widgets/main/settings/content_switch.dart';
import 'package:watchlistfy/widgets/main/settings/profile_stats_switch.dart';
import 'package:watchlistfy/widgets/main/settings/settings_content_selection.dart';
import 'package:watchlistfy/widgets/main/settings/user_list_switch.dart';

class SettingsApplicationPage extends StatelessWidget {
  const SettingsApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final cupertinoTheme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsList(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
              brightness: cupertinoTheme.brightness,
              platform: DevicePlatform.iOS,
              applicationType: ApplicationType.cupertino,
              sections: [
                SettingsSection(
                  title: const Text("Application"),
                  tiles: [
                    const CustomSettingsTile(child: ContentSwitch()),
                    const CustomSettingsTile(child: ConsumeLaterSwitch()),
                    const CustomSettingsTile(child: UserListSwitch()),
                    const CustomSettingsTile(child: ProfileStatsSwitch()),
                    CustomSettingsTile(
                      child: SettingsTile(
                        leading: Icon(
                          globalProvider.contentType == ContentType.movie
                          ? FontAwesomeIcons.ticket
                          : globalProvider.contentType == ContentType.tv
                            ? CupertinoIcons.tv_fill
                            : globalProvider.contentType == ContentType.anime
                              ? FontAwesomeIcons.userNinja
                              : FontAwesomeIcons.gamepad
                        ),
                        title: const Text('Default Selection'),
                        trailing: SettingsContentSelection(globalProvider),
                      ),
                    ),
                    SettingsTile.navigation(
                      leading: const FaIcon(FontAwesomeIcons.globe),
                      title: Text('Region: ${globalProvider.selectedCountryCode}'),
                      onPressed: (ctx) {
                        showCountryPicker(
                          context: context,
                          useSafeArea: true,
                          showPhoneCode: false,
                          countryListTheme: CountryListThemeData(
                            flagSize: 35,
                            backgroundColor: CupertinoTheme.of(context).onBgColor,
                            searchTextStyle: TextStyle(fontSize: 16, color: CupertinoTheme.of(context).bgTextColor),
                            textStyle: TextStyle(fontSize: 16, color: CupertinoTheme.of(context).bgTextColor),
                            bottomSheetHeight: 500,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            inputDecoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Start typing to search',
                              hintStyle: const TextStyle(color: CupertinoColors.systemGrey2),
                              prefixIcon: const Icon(CupertinoIcons.search),
                              prefixIconColor: CupertinoTheme.of(context).bgTextColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CupertinoTheme.of(context).bgTextColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          onSelect: (Country country) {
                            globalProvider.setSelectedCountry(country.countryCode);
                          },
                        );
                      },
                    ),
                  ]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}