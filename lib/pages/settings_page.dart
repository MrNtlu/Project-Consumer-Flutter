import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:watchlistfy/models/auth/user_info.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
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
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/settings/theme_switch.dart';
import 'package:http/http.dart' as http;
import 'package:watchlistfy/widgets/main/settings/user_list_switch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /* TODO
  * - [ ] OnBoarding Page
  *  - Make use enter new entries etc.
  *  - For each content type, show popular ones.
  *  - Allow user to skip or add 3 movies.(Create endpoint for that)
  * - [ ] Default content type selection
  * - [ ] Add new content cell design and allow user to select
  */
  DetailState _state = DetailState.init;
  String? error;
  UserInfo? _userInfo;

  late final AuthenticationProvider authProvider;

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
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.getBaseMessageResponse().error!)
          );
        } else {
          Purchases.logOut();
          GoogleSignInApi().signOut();
          SharedPref().deleteTokenCredentials();
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        }
      });
    } catch (error) {
      setState(() {
        _state = DetailState.view;
      });
      showDialog(
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
          showDialog(
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
              authProvider.setAuthentication(false);
              authProvider.setBasicUserInfo(null);
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
      showDialog(
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
        Uri.parse(APIRoutes().userRoutes.info),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (_state != DetailState.disposed) {
          _userInfo = response.getBaseItemResponse<UserInfo>().data;
          error = _userInfo == null ? response.getBaseItemResponse<UserInfo>().message : null;

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
      themeProvider.initTheme(SharedPref().isDarkTheme());

      authProvider = Provider.of<AuthenticationProvider>(context);

      if (authProvider.isAuthenticated) {
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
      : SettingsList(
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
              const CustomSettingsTile(child: UserListSwitch()),
            ]
          ),
          SettingsSection(
            title: const Text("Account"),
            tiles: [
              if (_userInfo != null)
              _userInfoText("Email", _userInfo!.email),
              if (_userInfo != null)
              _userInfoText("Username", _userInfo!.username),
              if (_userInfo != null)
              _userInfoText("Membership", _userInfo!.isPremium ? "Premium" : "Free"),
              if (authProvider.isAuthenticated)
              SettingsTile.navigation(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Logout'),
                onPressed: (ctx) {
                  _logOut();
                },
              ),
              if (!authProvider.isAuthenticated)
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
              if (authProvider.isAuthenticated)
              SettingsTile.navigation(
                leading: const Icon(Icons.delete_forever_rounded),
                title: const Text('Delete Account'),
                onPressed: (ctx) {
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
            ]
          )
        ],
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
