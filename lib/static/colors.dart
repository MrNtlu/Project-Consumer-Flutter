import 'package:flutter/cupertino.dart';

extension ColorSchemeExt on CupertinoThemeData {
  Color get bottomNavBgColor => brightness == Brightness.dark
      ? const Color(0xFF212121)
      : const Color(0xFFFAFAFA);
  Color get bgColor => brightness == Brightness.dark
      ? const Color(0xFF121212)
      : const Color(0xFFFAFAFA);
  Color get onBgColor => brightness == Brightness.dark
      ? const Color(0xFF212121)
      : const Color(0xFFFFFFFF);
  Color get bgTextColor => brightness == Brightness.dark
      ? CupertinoColors.white
      : CupertinoColors.black;
  Color get profileButton => brightness == Brightness.dark
      ? const Color(0xFF1C2129)
      : const Color(0xFFedf3fd);
  Color get navigationBarBackgroundColor => barBackgroundColor;
}

class AppColors {
  final primaryColor = const Color(0xFF2196F3);
  final darkBackgroundColor = const Color(0xFF121212);
  final onDarkBackgroundColor = const Color(0xFF212121);
  final lightBackgroundColor = const Color(0xFFFAFAFA);
  final onLightBackgroundColor = const Color(0xFFFFFFFF);

  final darkTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF2196F3),
    barBackgroundColor: Color(0xFF212121),
    scaffoldBackgroundColor: Color(0xFF121212),
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(
        color: CupertinoColors.white,
      ),
      actionTextStyle: TextStyle(
        color: CupertinoColors.white,
      ),
    ),
  );

  final lightTheme = const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF2196F3),
    barBackgroundColor: CupertinoColors.white,
    scaffoldBackgroundColor: Color(0xFFFAFAFA),
    textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
      color: CupertinoColors.black,
    )),
  );
}
