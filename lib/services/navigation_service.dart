import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? context;

  static Future<void> pushRoute(Widget widget) async {
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!
          .push(MaterialPageRoute(builder: (context) => widget));
    } else {
      debugPrint("pushRoute error");
    }
  }
}
