import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/auth/requests/login.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/auth/auth_switch.dart';
import 'package:watchlistfy/widgets/auth/email_field.dart';
import 'package:watchlistfy/widgets/auth/password_field.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/loading_dialog.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/profile_image_list.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isInit = false;

  final _registerModel = Register('', '', '', '', '');

  late final AuthSwitch _termsConditionsCheck;
  late final AuthSwitch _privacyPolicyCheck;
  late final TextEditingController _emailTextController;
  late final TextEditingController _usernameTextController;
  late final TextEditingController _passwordTextController;
  late final ProfileImageList _profileImageList;

  void _onRegisterPressed() async {
    if (_termsConditionsCheck.getValue() && _privacyPolicyCheck.getValue()) {
      if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty || _usernameTextController.text.isEmpty) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => const ErrorDialog("Please don't leave anything empty.")
        );
        return;
      } else if (!_emailTextController.text.isEmailValid()) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => const ErrorDialog("Invalid email address.")
        );
        return;
      }

      showCupertinoDialog(context: context, builder: (_) => const LoadingDialog());

      _registerModel.emailAddress = _emailTextController.text;
      _registerModel.password = _passwordTextController.text;
      _registerModel.username = _usernameTextController.text;
      _registerModel.image = Constants.ProfileImageList[_profileImageList.selectedIndex];

      String? token = await FirebaseMessaging.instance.getToken();
      _registerModel.fcmToken = token ?? '';

      _registerModel.register().then((value){
        Navigator.pop(context);

        if (value.error != null) {
          showCupertinoDialog(context: context, builder: (_) => ErrorDialog(value.error ?? value.message ?? ''));
        } else {
          Navigator.pop(context);

          showCupertinoDialog(context: context, builder: (_) => MessageDialog(value.message ?? "Successfully registered."));
        }
      }).catchError((error){
        Navigator.pop(context);
        showCupertinoDialog(context: context, builder: (_) => ErrorDialog(error));
      });
    } else {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => const ErrorDialog("Please accept Terms & Conditions and Privacy Policy")
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _termsConditionsCheck = AuthSwitch("Terms & Conditions", false);
      _privacyPolicyCheck = AuthSwitch("Privacy Policy", true);
      _emailTextController = TextEditingController();
      _passwordTextController = TextEditingController();
      _usernameTextController = TextEditingController();
      _profileImageList = ProfileImageList();

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text("Register", style: TextStyle(fontSize: 24)),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    _profileImageList,
                    const SizedBox(height: 24),
                    EmailField(_emailTextController),
                    const SizedBox(height: 24),
                    EmailField(_usernameTextController, label: "Username"),
                    const SizedBox(height: 24),
                    PasswordField(_passwordTextController),
                    const SizedBox(height: 16),
                    _termsConditionsCheck,
                    _privacyPolicyCheck,
                    const SizedBox(height: 32),
                    CupertinoButton.filled(
                        child: const Text(
                          "Register",
                          style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        onPressed: () {
                          _onRegisterPressed();
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an Account?", style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 6),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
