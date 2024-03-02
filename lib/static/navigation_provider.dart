import 'dart:io';

import 'package:flutter/cupertino.dart';

class NavigationTracker extends ChangeNotifier {
  int stackSize = 0;

  bool shouldMaintainState() {
    if (Platform.isIOS && stackSize < 7) {
      return true;
    } else if (stackSize < 10) {
      return true;
    }

    return false;
  }

  NavigationTracker._privateConstructor();

  static final NavigationTracker _instance =
      NavigationTracker._privateConstructor();

  factory NavigationTracker() {
    return _instance;
  }
}
