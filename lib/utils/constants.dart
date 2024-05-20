import 'package:flutter/material.dart';
import 'package:task_manager/services/navigation_service.dart';

class Constant {
  static void showMessage(String text) {
    var context = NavigationService.navigatorKey.currentContext;
    if (NavigationService.navigatorKey.currentState != null &&
        context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    } else {
      debugPrint("showMessage error");
    }
  }
}
