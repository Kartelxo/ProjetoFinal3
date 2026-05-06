import 'package:flutter/material.dart';

class AppDialog {
  static Future<T?> show<T>(BuildContext context, {required Widget title, Widget? content, List<Widget>? actions}) {
    return showDialog<T>(context: context, builder: (_) => AlertDialog(title: title, content: content, actions: actions));
  }
}
