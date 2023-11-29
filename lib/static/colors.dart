import 'package:flutter/cupertino.dart';

extension ColorSchemeExt on CupertinoThemeData {
  Color get bottomNavBgColor => brightness == Brightness.dark ? const Color(0xFF212121) : const Color(0xFFFAFAFA);
  Color get bgColor => brightness == Brightness.dark ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
  Color get onBgColor => brightness == Brightness.dark ? const Color(0xFF212121) : const Color(0xFFFFFFFF);
  Color get bgTextColor => brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.black;
}

class AppColors {
  final primaryColor = const Color(0xFF00579B);
  final darkBackgroundColor = const Color(0xFF121212);
  final onDarkBackgroundColor = const Color(0xFF212121);
  final lightBackgroundColor = const Color(0xFFFAFAFA);
  final onLightBackgroundColor = const Color(0xFFFFFFFF);

  final darkTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF00579B),
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
    primaryColor: Color(0xFF00579B),
    barBackgroundColor: CupertinoColors.white,
    scaffoldBackgroundColor: Color(0xFFFAFAFA),
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(
        color: CupertinoColors.black,
      )
    ),
  );
}