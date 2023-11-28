import 'package:flutter/cupertino.dart';

extension ColorSchemeExt on CupertinoThemeData {
  Color get bgColor => brightness == Brightness.dark ? const Color(0xFF212121) : const Color(0xFFFAFAFA);
  Color get bgTextColor => brightness == Brightness.dark ? CupertinoColors.white : CupertinoColors.black;
}

class AppColors {
  final primaryColor = const Color(0xFF00579B);
  final darkBackgroundColor = const Color(0xFF212121);
  final lightBackgroundColor = const Color(0xFFFAFAFA);

  final darkTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF00579B),
    barBackgroundColor: Color(0xFF212121),
    scaffoldBackgroundColor: Color(0xFF212121),
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