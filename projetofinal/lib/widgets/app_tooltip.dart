import 'package:flutter/material.dart';

class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const AppTooltip({Key? key, required this.message, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Tooltip(message: message, child: child);
}
