import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';
import 'package:watchlistfy/pages/auth/policy_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/theme_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:watchlistfy/static/google_signin_api.dart';
import 'package:watchlistfy/static/purchase_api.dart';
import 'package:watchlistfy/static/routes.dart';
import 'package:watchlistfy/static/shared_pref.dart';
import 'package:watchlistfy/static/token.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/settings/change_password_sheet.dart';
import 'package:watchlistfy/widgets/main/settings/change_username_sheet.dart';
import 'package:watchlistfy/widgets/main/settings/consume_later_switch.dart';
import 'package:watchlistfy/widgets/main/settings/content_switch.dart';
import 'package:watchlistfy/widgets/main/settings/offers_sheet.dart';
import 'package:watchlistfy/widgets/main/settings/settings_content_selection.dart';
import 'package:watchlistfy/widgets/main/settings/theme_switch.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/widgets/main/settings/user_list_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /* TODO
  * - [ ] Default content type selection
  */
  DetailState _state = DetailState.init;
  String? error;
  BasicUserInfo? _userInfo;

  AuthenticationProvider? authProvider;
  GlobalProvider? globalProvider;

  void _deleteUserAccount() {
    setState(() {
      _state = DetailState.loading;
    });
    try {
      http.delete(
        Uri.parse(APIRoutes().userRoutes.deleteUser),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (response.getBaseMessageResponse().error != null) {
          setState(() {
            _state = DetailState.view;
          });
          showCupertinoDialog(
            context: context,
            builder: (ctx) => ErrorDialog(response.getBaseMessageResponse().error!)
          );
        } else {
          authProvider?.setAuthentication(false);
          authProvider?.setBasicUserInfo(null);
          Purchases.logOut();
          UserToken().setToken(null);
          GoogleSignInApi().signOut();
          SharedPref().deleteTokenCredentials();
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        }
      });
    } catch (error) {
      setState(() {
        _state = DetailState.view;
      });
      showCupertinoDialog(
        context: context,
        builder: (ctx) => ErrorDialog(error.toString())
      );
    }
  }

  void _logOut() {
    setState(() {
      _state = DetailState.loading;
    });
    try {
      http.post(
        Uri.parse(APIRoutes().authRoutes.logout),
        headers: UserToken().getBearerToken()
      ).then((response) async {
        if (response.getBaseMessageResponse().error != null) {
          setState(() {
            _state = DetailState.view;
          });
          showCupertinoDialog(
            context: context,
            builder: (_) => ErrorDialog(response.getBaseMessageResponse().error!)
          );
        } else {
          try {
            await Purchases.logOut();
            SharedPref().deleteTokenCredentials();

            if (PurchaseApi().userInfo != null && PurchaseApi().userInfo!.isOAuth) {
              switch (PurchaseApi().userInfo!.oAuthType) {
                case 0:
                  await GoogleSignInApi().signOut();
                  break;
                default:
                  await GoogleSignInApi().signOut();
              }
            } else if (PurchaseApi().userInfo == null) {
              await GoogleSignInApi().signOut();
            }
            if (context.mounted) {
              authProvider?.setAuthentication(false);
              authProvider?.setBasicUserInfo(null);
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            }
          } catch (error) {
            setState(() {
              _state = DetailState.view;
            });
            if (context.mounted) {
              showCupertinoDialog(
                context: context,
                builder: (_) => ErrorDialog(error.toString())
              );
            }
          }
        }
      });
    } catch (error) {
      setState(() {
        _state = DetailState.view;
      });
      showCupertinoDialog(
        context: context,
        builder: (ctx) => ErrorDialog(error.toString())
      );
    }
  }

  void _getUserInfo() {
    setState(() {
      _state = DetailState.loading;
    });

    try {
      http.get(
        Uri.parse(APIRoutes().userRoutes.basic),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (_state != DetailState.disposed) {
          _userInfo = response.getBaseItemResponse<BasicUserInfo>().data;
          error = _userInfo == null ? response.getBaseItemResponse<UserInfo>().message : null;

          if (_userInfo != null && PurchaseApi().userInfo == null) {
            PurchaseApi().userInfo = _userInfo;
          }

          setState(() {
            _state = _userInfo == null ? DetailState.error : DetailState.view;
          });
        }
      }).onError((error, stackTrace) {
        this.error = error.toString();
        setState(() {
          _state = DetailState.error;
        });
      });
    } catch(error) {
      this.error = error.toString();
      setState(() {
        _state = DetailState.error;
      });
    }
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      globalProvider = Provider.of<GlobalProvider>(context);
      themeProvider.initTheme(SharedPref().isDarkTheme());

      authProvider = Provider.of<AuthenticationProvider>(context);

      if (authProvider?.isAuthenticated == true) {
        _getUserInfo();
      }
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
        brightness: cupertinoTheme.brightness,
      ),
      child: _state == DetailState.loading
      ? const LoadingView("Loading")
      : SingleChildScrollView(
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
                    CustomSettingsTile(child: ThemeSwitch(() {
                      setState(() {
                        _state = DetailState.view;
                      });
                    })),
                    const CustomSettingsTile(child: ContentSwitch()),
                    const CustomSettingsTile(child: UserListSwitch()),
                    const CustomSettingsTile(child: ConsumeLaterSwitch()),
                    if (globalProvider != null)
                    CustomSettingsTile(
                      child: SettingsTile(
                        leading: Icon(
                          globalProvider!.contentType == ContentType.movie
                          ? FontAwesomeIcons.ticket
                          : globalProvider!.contentType == ContentType.tv
                            ? CupertinoIcons.tv_fill
                            : globalProvider!.contentType == ContentType.anime
                              ? FontAwesomeIcons.userNinja
                              : FontAwesomeIcons.gamepad
                        ),
                        title: const Text('Default Selection'),
                        trailing: SettingsContentSelection(globalProvider!),
                      ),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(CupertinoIcons.globe),
                      title: Text('Region: ${globalProvider?.selectedCountryCode ?? 'US'}'),
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
                            globalProvider?.setSelectedCountry(country.countryCode);
                          },
                        );
                      },
                    ),
                  ]
                ),
                SettingsSection(
                  title: const Text("Account"),
                  tiles: [
                    if (_userInfo != null && authProvider?.isAuthenticated == true && !_userInfo!.isPremium)
                    SettingsTile.navigation(
                      leading: Lottie.asset(
                        "assets/lottie/premium.json",
                        height: 36,
                        width: 36,
                        frameRate: FrameRate(60)
                      ),
                      title: const Text('Upgrade Account'),
                      onPressed: (ctx) {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            return const OffersSheet();
                          })
                        );
                      },
                    ),
                    if (_userInfo != null)
                    _userInfoText("Email", _userInfo!.email),
                    if (_userInfo != null)
                    _userInfoText("Username", _userInfo!.username),
                    if (_userInfo != null)
                    _userInfoText("Membership", _userInfo!.isPremium ? "Premium" : "Free"),
                    if (authProvider?.isAuthenticated == true && _userInfo?.canChangeUsername == true)
                    SettingsTile.navigation(
                      leading: const Icon(CupertinoIcons.person_2_fill),
                      title: const Text('Change Username'),
                      onPressed: (ctx) {
                        showCupertinoModalBottomSheet(
                          context: context,
                          barrierColor: CupertinoColors.black.withOpacity(0.75),
                          builder: (_) => const ChangeUsernameSheet()
                        );
                      },
                    ),
                    if (authProvider?.isAuthenticated == true)
                    SettingsTile.navigation(
                      leading: const Icon(Icons.password_rounded),
                      title: const Text('Change Password'),
                      onPressed: (ctx) {
                        showCupertinoModalBottomSheet(
                          context: context,
                          barrierColor: CupertinoColors.black.withOpacity(0.75),
                          builder: (_) => const ChangePasswordSheet()
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(CupertinoIcons.mail_solid),
                      title: const Text('Feedback & Suggestions'),
                      onPressed: (ctx) async {
                        final url = Uri.parse('mailto:mrntlu@gmail.com');
                        if (!await  launchUrl(url) && context.mounted) {
                          showCupertinoDialog(
                            context: context,
                            builder: (_) => const MessageDialog("You can send email to, mrntlu@gmail.com", title: "Contact Us")
                          );
                        }
                      },
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.reviews_rounded),
                      title: const Text('Review & Support Us'),
                      onPressed: (ctx) async {
                        final InAppReview inAppReview = InAppReview.instance;

                        inAppReview.openStoreListing(appStoreId: 'id6476311748');
                      },
                    ),
                    if (authProvider?.isAuthenticated == true)
                    SettingsTile.navigation(
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text('Logout'),
                      onPressed: (ctx) {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) {
                            return SureDialog("Do you want to logout?", () {
                              _logOut();
                            });
                          }
                        );
                      },
                    ),
                    if (authProvider?.isAuthenticated == false)
                    SettingsTile.navigation(
                      leading: const Icon(Icons.login_rounded),
                      title: const Text('Login'),
                      onPressed: (ctx) {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            return LoginPage();
                          })
                        );
                      },
                    ),
                  ]
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text("Terms & Conditions"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(builder: (_) {
                        return const PolicyPage(false);
                      })
                    );
                  }
                ),
                CupertinoButton(
                  child: const Text("Privacy Policy"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(builder: (_) {
                        return const PolicyPage(true);
                      })
                    );
                  }
                )
              ],
            ),
            if (authProvider?.isAuthenticated == true)
            CupertinoButton(
              child: const Text('Delete Account', style: TextStyle(color: CupertinoColors.systemRed)),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return SureDialog("Do you want to delete your account? This action cannot be reversed!", () {
                      _deleteUserAccount();
                    });
                  }
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  SettingsTile _userInfoText(String title, String data) => SettingsTile(
    title: Row(
      children: [
        Text(title),
        const SizedBox(width: 8),
        Expanded(
          child: AutoSizeText(
            data,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
            maxLines: 1,
            maxFontSize: 16,
            minFontSize: 12,
          ),
        ),
      ],
    )
  );
}
