import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/main/settings/notification_switch.dart';
import 'package:http/http.dart' as http;

class SettingsNotificationPage extends StatelessWidget {
  final BasicUserInfo _userInfo;
  final bool isMail;

  const SettingsNotificationPage(this._userInfo, {this.isMail = true, super.key});

  void _changeMailNotifications(
    AuthenticationProvider authProvider,
    BuildContext context,
    bool promotions,
    bool updates,
    bool follows,
    bool reviewLikes,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (_) => const LoadingDialog()
    );

    try {
      http.patch(
        Uri.parse(
          isMail
          ? APIRoutes().userRoutes.changeMailNotification
          : APIRoutes().userRoutes.changeAppNotification
        ),
        headers: UserToken().getBearerToken(),
        body: json.encode({
          "promotions": promotions,
          "updates": updates,
          "follows": follows,
          "review_likes": reviewLikes,
        }),
      ).then((response){
        Navigator.pop(context);

        final error = response.getBaseItemResponse<UserInfo>().error;
        if (error == null) {
          if (isMail) {
            _userInfo.mailNotification.promotions = promotions;
            _userInfo.mailNotification.updates = updates;
            _userInfo.mailNotification.follows = follows;
            _userInfo.mailNotification.reviewLikes = reviewLikes;
          } else {
            _userInfo.appNotification.promotions = promotions;
            _userInfo.appNotification.updates = updates;
            _userInfo.appNotification.follows = follows;
            _userInfo.appNotification.reviewLikes = reviewLikes;
          }
          PurchaseApi().userInfo = _userInfo;
          authProvider.setBasicUserInfo(_userInfo);
        } else {
          showCupertinoDialog(
            context: context,
            builder: (_) => ErrorDialog(error.toString())
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
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final cupertinoTheme = CupertinoTheme.of(context);

    final promotionSwitch = NotificationSwitch(
      "Promotion",
      FontAwesomeIcons.rectangleAd,
      value: isMail
      ? _userInfo.mailNotification.promotions
      : _userInfo.appNotification.promotions,
    );

    final updateSwitch = NotificationSwitch(
      "What's New Update",
      FontAwesomeIcons.solidNewspaper,
      value: isMail
      ? _userInfo.mailNotification.updates
      : _userInfo.appNotification.updates,
    );

    // final followSwitch = NotificationSwitch(
    //   "Follows",
    //   FontAwesomeIcons.rectangleAd,
    //   isMail
    //   ? _userInfo.mailNotification.follows
    //   : _userInfo.appNotification.follows,
    // );

    // final reviewLikesSwitch = NotificationSwitch(
    //   "Review Likes",
    //   FontAwesomeIcons.rectangleAd,
    //   isMail
    //   ? _userInfo.mailNotification.reviewLikes
    //   : _userInfo.appNotification.reviewLikes,
    // );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("${isMail ? "Mail" : "In-App"} Notifications"),
      ),
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
                  tiles: [
                    CustomSettingsTile(child: promotionSwitch),
                    CustomSettingsTile(child: updateSwitch),
                    // CustomSettingsTile(child: followSwitch),
                    // CustomSettingsTile(child: reviewLikesSwitch),
                    CustomSettingsTile(
                      child: SettingsTile(
                        trailing: const Icon(
                          FontAwesomeIcons.floppyDisk,
                          color: CupertinoColors.activeBlue,
                        ),
                        title: const Text(
                          'Save Preferences',
                          style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)
                        ),
                        onPressed: (context) {
                          _changeMailNotifications(
                            authProvider,
                            context,
                            promotionSwitch.value,
                            updateSwitch.value,
                            false,
                            false,
                          );
                        },
                      ),
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